import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/core/services/logger_service.dart';
import 'package:tictac/features/game/data/services/firebase_game_backend_service.dart';
import 'package:tictac/features/game/domain/entities/game_state.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnapshot;
  late MockLoggerService mockLogger;
  late FirebaseGameBackendService service;

  const String testGameId = 'test-game-123';
  final Map<String, Object> testGameData = <String, Object>{
    'board': <List<String>>[
      <String>['Player.x', 'Player.o', 'Player.none'],
      <String>['Player.none', 'Player.x', 'Player.o'],
      <String>['Player.none', 'Player.none', 'Player.x'],
    ],
    'currentPlayer': 'Player.o',
    'status': 'GameStatus.playing',
    'gameId': testGameId,
    'playerId': 'player-456',
    'isOnline': true,
  };

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnapshot = MockDocumentSnapshot();
    mockLogger = MockLoggerService();

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);
    when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
    when(() => mockDocRef.snapshots()).thenAnswer((_) => Stream<DocumentSnapshot<Map<String, dynamic>>>.value(mockDocSnapshot));
    when(() => mockDocRef.update(any())).thenAnswer((_) async => Future<void>.value());

    service = FirebaseGameBackendService(mockFirestore, mockLogger);
  });

  group('joinGame', () {
    test('should return GameState when game exists', () async {
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testGameData);

      final GameState result = await service.joinGame(testGameId);

      expect(result, isA<GameState>());
      expect(result.gameId, testGameId);
      expect(result.board.length, 3);
      verify(() => mockDocRef.get()).called(1);
    });

    test('should throw exception when game does not exist', () async {
      when(() => mockDocSnapshot.exists).thenReturn(false);

      expect(
        () => service.joinGame(testGameId),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception on Firestore error', () async {
      when(() => mockDocRef.get()).thenThrow(Exception('Firestore connection error'));

      expect(
        () => service.joinGame(testGameId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('makeMove', () {
    test('should update board and return new GameState', () async {
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testGameData);

      final GameState result = await service.makeMove(testGameId, 1, 0, Player.o);

      expect(result, isA<GameState>());
      verify(() => mockDocRef.get()).called(2);
      verify(() => mockDocRef.update(any())).called(1);
    });

    test('should throw exception when game does not exist', () async {
      when(() => mockDocSnapshot.exists).thenReturn(false);

      expect(
        () => service.makeMove(testGameId, 0, 0, Player.x),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception on update error', () async {
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testGameData);
      when(() => mockDocRef.update(any())).thenThrow(Exception('Update failed'));

      expect(
        () => service.makeMove(testGameId, 0, 0, Player.x),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getGameState', () {
    test('should return GameState when game exists', () async {
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testGameData);

      final GameState result = await service.getGameState(testGameId);

      expect(result, isA<GameState>());
      expect(result.gameId, testGameId);
      verify(() => mockDocRef.get()).called(1);
    });

    test('should throw exception when game does not exist', () async {
      when(() => mockDocSnapshot.exists).thenReturn(false);

      expect(
        () => service.getGameState(testGameId),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('watchGame', () {
    test('should emit GameState when document updates', () async {
      final StreamController<DocumentSnapshot<Map<String, dynamic>>> controller = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
      when(() => mockDocRef.snapshots()).thenAnswer((_) => controller.stream);
      when(() => mockDocSnapshot.exists).thenReturn(true);
      when(() => mockDocSnapshot.data()).thenReturn(testGameData);

      final Stream<GameState> stream = service.watchGame(testGameId);

      expect(stream, emits(isA<GameState>()));

      controller.add(mockDocSnapshot);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.close();
    });

    test('should throw exception when game does not exist in stream', () async {
      final StreamController<DocumentSnapshot<Map<String, dynamic>>> controller = StreamController<DocumentSnapshot<Map<String, dynamic>>>();
      when(() => mockDocRef.snapshots()).thenAnswer((_) => controller.stream);
      when(() => mockDocSnapshot.exists).thenReturn(false);

      final Stream<GameState> stream = service.watchGame(testGameId);

      expect(stream, emitsError(isA<Exception>()));

      controller.add(mockDocSnapshot);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      await controller.close();
    });
  });

  group('leaveGame', () {
    test('should complete normally', () async {
      await service.leaveGame(testGameId);
      expect(true, isTrue);
    });

    test('should handle multiple calls gracefully', () async {
      await service.leaveGame(testGameId);
      await service.leaveGame(testGameId);
      expect(true, isTrue);
    });
  });
}
