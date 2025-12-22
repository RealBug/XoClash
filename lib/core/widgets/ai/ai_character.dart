import 'package:flutter/material.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/constants/game_constants.dart';
import 'package:tictac/core/extensions/localizations_extension.dart';

class AICharacter {

  const AICharacter({
    required this.name,
    required this.emoji,
    required this.color,
    required this.difficulty,
  });
  final String name;
  final String emoji;
  final Color color;
  final int difficulty;

  static const Map<int, AICharacter> _characters = <int, AICharacter>{
    GameConstants.aiEasyDifficulty: AICharacter(
      name: AppConstants.aiCharacterNameEasy,
      emoji: '🌱',
      color: Color(0xFF4CAF50),
      difficulty: GameConstants.aiEasyDifficulty,
    ),
    GameConstants.aiMediumDifficulty: AICharacter(
      name: AppConstants.aiCharacterNameMedium,
      emoji: '⚡',
      color: Color(0xFFFF9800),
      difficulty: GameConstants.aiMediumDifficulty,
    ),
    GameConstants.aiHardDifficulty: AICharacter(
      name: AppConstants.aiCharacterNameHard,
      emoji: '👑',
      color: Color(0xFFF44336),
      difficulty: GameConstants.aiHardDifficulty,
    ),
  };

  static const Map<int, String> _playerIds = <int, String>{
    GameConstants.aiEasyDifficulty: AppConstants.aiPlayerNameEasy,
    GameConstants.aiMediumDifficulty: AppConstants.aiPlayerNameMedium,
    GameConstants.aiHardDifficulty: AppConstants.aiPlayerNameHard,
  };

  static AICharacter getCharacter(int difficulty) {
    return _characters[difficulty] ?? _characters[GameConstants.aiEasyDifficulty]!;
  }

  String getSubtitle(BuildContext context) {
    return switch (difficulty) {
      GameConstants.aiEasyDifficulty => context.l10n.aiEasySubtitle,
      GameConstants.aiMediumDifficulty => context.l10n.aiMediumSubtitle,
      GameConstants.aiHardDifficulty => context.l10n.aiHardSubtitle,
      _ => context.l10n.aiEasySubtitle,
    };
  }

  String getDisplayName(BuildContext context) {
    return switch (difficulty) {
      GameConstants.aiEasyDifficulty => context.l10n.aiEasy,
      GameConstants.aiMediumDifficulty => context.l10n.aiMedium,
      GameConstants.aiHardDifficulty => context.l10n.aiHard,
      _ => context.l10n.aiEasy,
    };
  }

  static String getComputerPlayerId(int difficulty) {
    return _playerIds[difficulty] ?? AppConstants.aiPlayerNameEasy;
  }
}
