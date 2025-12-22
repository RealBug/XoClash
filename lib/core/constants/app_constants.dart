/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Default values
  static const String defaultShape = 'classic';
  static const String defaultPlayerSymbolX = 'X';
  static const String defaultPlayerSymbolO = 'O';

  // UI Strings
  static const String appNameShort = 'XO';
  static const String appTitlePart1 = 'XO';
  static const String appTitlePart2 = 'CLASH';

  // Storage keys
  static const String storageKeySettings = 'app_settings';
  static const String storageKeyGames = 'saved_games';
  static const String storageKeyHistory = 'game_history';
  static const String storageKeyScores = 'player_scores';
  static const String storageKeyUsername = 'user_username';
  static const String storageKeyEmail = 'user_email';
  static const String storageKeyAvatar = 'user_avatar';

  // AI player names
  static const String aiPlayerNameEasy = 'AI_Easy';
  static const String aiPlayerNameMedium = 'AI_Medium';
  static const String aiPlayerNameHard = 'AI_Hard';
  static const String aiPlayerNamePrefix = 'AI_';

  // AI character names
  static const String aiCharacterNameEasy = 'easy';
  static const String aiCharacterNameMedium = 'medium';
  static const String aiCharacterNameHard = 'hard';

  // Game ID generation
  static const String gameIdChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int gameIdLength = 6;
  static const String offlineGameIdPrefix = 'offline_';

  // Username validation
  static const int minUsernameLength = 2;
  static const int maxUsernameLength = 20;

  // History
  static const int maxHistorySize = 100;

  // Symbol size factors
  static const double roundedOutlineSymbolSizeFactor = 0.78;
  static const double shapeSelectorBaseSize = 36.0;

  // Hero animation tags
  static const String heroTagAppLogo = 'app_logo';
}
