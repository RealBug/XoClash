import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/services/game_backend_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

@Injectable(as: GameBackendService)
class FirebaseGameBackendService implements GameBackendService {

  FirebaseGameBackendService(
    @factoryParam FirebaseFirestore? firestore,
    this._logger,
  ) : _firestoreParam = firestore;
  final FirebaseFirestore? _firestoreParam;
  final LoggerService _logger;
  final Map<String, StreamSubscription<dynamic>> _subscriptions = <String, StreamSubscription<dynamic>>{};

  late final FirebaseFirestore _firestore =
      _firestoreParam ?? _getFirestoreOrThrow();

  FirebaseFirestore _getFirestoreOrThrow() {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      _logger.error(
        'Firebase not initialized. Online mode unavailable. '
        'Run "flutterfire configure" to enable online multiplayer.',
        e,
      );
      rethrow;
    }
  }

  CollectionReference<Map<String, dynamic>> get _gamesCollection =>
      _firestore.collection('games');

  @override
  Future<GameState> joinGame(String gameId) async {
    _logger.info('Joining game via Firestore: $gameId');
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _gamesCollection.doc(gameId).get();

      if (!doc.exists) {
        throw Exception('Game not found: $gameId');
      }

      final Map<String, dynamic> data = doc.data()!;
      _logger.debug('Successfully joined game: $gameId');
      return GameState.fromJson(data);
    } catch (e, stackTrace) {
      _logger.error('Failed to join game: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<GameState> makeMove(
    String gameId,
    int row,
    int col,
    Player player,
  ) async {
    _logger.debug(
        'Making move in Firestore game $gameId: player=$player, row=$row, col=$col');

    try {
      final DocumentReference<Map<String, dynamic>> docRef = _gamesCollection.doc(gameId);
      final DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Game not found: $gameId');
      }

      final GameState currentState = GameState.fromJson(doc.data()!);
      final List<List<Player>> newBoard = List<List<Player>>.from(
        currentState.board.map((List<Player> row) => List<Player>.from(row)),
      );
      newBoard[row][col] = player;

      await docRef.update(<Object, Object?>{
        'board':
            newBoard.map((List<Player> r) => r.map((Player p) => p.toString()).toList()).toList(),
        'lastMove': <String, Object>{'row': row, 'col': col, 'player': player.toString()},
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final DocumentSnapshot<Map<String, dynamic>> updatedDoc = await docRef.get();
      _logger.debug('Move successful in game: $gameId');
      return GameState.fromJson(updatedDoc.data()!);
    } catch (e, stackTrace) {
      _logger.error('Failed to make move in game: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<GameState> getGameState(String gameId) async {
    _logger.debug('Getting game state from Firestore: $gameId');
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _gamesCollection.doc(gameId).get();

      if (!doc.exists) {
        throw Exception('Game not found: $gameId');
      }

      return GameState.fromJson(doc.data()!);
    } catch (e, stackTrace) {
      _logger.error('Failed to get game state: $gameId', e, stackTrace);
      rethrow;
    }
  }

  @override
  Stream<GameState> watchGame(String gameId) {
    _logger.info('Watching Firestore game: $gameId');

    return _gamesCollection.doc(gameId).snapshots().map<GameState>((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (!snapshot.exists) {
        throw Exception('Game not found: $gameId');
      }

      _logger.debug('Game update received from Firestore: $gameId');
      return GameState.fromJson(snapshot.data()!);
    }).handleError((Object error, StackTrace stackTrace) {
      _logger.error(
          'Firestore stream error for game: $gameId', error, stackTrace);
      throw error;
    });
  }

  @override
  Future<void> leaveGame(String gameId) async {
    _logger.info('Leaving Firestore game: $gameId');
    final StreamSubscription<dynamic>? subscription = _subscriptions.remove(gameId);
    await subscription?.cancel();
  }
}
