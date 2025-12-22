import 'package:tictac/features/game/domain/entities/game_state.dart';

class WinMessageData {

  const WinMessageData({
    required this.displayName,
    required this.useYouWon,
  });
  final String displayName;
  final bool useYouWon;
}

class GetWinMessageUseCase {
  WinMessageData execute({
    required String? playerName,
    required String defaultName,
    required GameState gameState,
    required bool isCurrentUser,
  }) {
    final String displayName = (playerName == null || playerName.isEmpty) 
        ? defaultName 
        : playerName;
    
    final bool useYouWon = gameState.gameMode != GameModeType.offlineFriend && isCurrentUser;
    
    return WinMessageData(
      displayName: displayName,
      useYouWon: useYouWon,
    );
  }
}

