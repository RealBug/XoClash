// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'XO Clash';

  @override
  String get welcome => 'Welcome!';

  @override
  String get welcomeMessage => 'Challenge friends or AI, anytime, anywhere';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get welcomeBack => 'Good to see you again!';

  @override
  String get createAccount => 'Create Account';

  @override
  String get enterUsernameToLogin => 'Sign in with your account';

  @override
  String get playAsGuest => 'Play as Guest';

  @override
  String get signupWithEmail => 'Sign up with Email';

  @override
  String get signupWithGoogle => 'Sign up with Google';

  @override
  String get signupWithApple => 'Sign up with Apple';

  @override
  String get loginWithEmail => 'Login with Email';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get loginWithApple => 'Login with Apple';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordMessage =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get passwordResetEmailSent =>
      'Password reset link has been sent to your email';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get chooseUsername => 'Choose a username to start playing';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get start => 'Start';

  @override
  String hello(String username) {
    return 'Ready to play, $username?';
  }

  @override
  String get playOnline => 'Choose your opponent and let\'s go!';

  @override
  String get newGame => 'New Game';

  @override
  String get or => 'OR';

  @override
  String get joinGame => 'Join';

  @override
  String get gameCode => 'Game Code';

  @override
  String get enterGameCode => 'Game Code';

  @override
  String get gameNotFound =>
      'Game not found. Please check the code and try again.';

  @override
  String get failedToJoinGame => 'Failed to join game. Please try again.';

  @override
  String get invalidGameCode => 'Invalid game code format';

  @override
  String get chooseBoardSize => 'Choose board size';

  @override
  String get winCondition =>
      'To win, align 3 consecutive symbols\n(horizontal, vertical or diagonal)';

  @override
  String get winCondition4 =>
      'To win, align 4 consecutive symbols\n(horizontal, vertical or diagonal)';

  @override
  String get threeInARow => '3 in a row to win';

  @override
  String get fourInARow => '4 in a row to win';

  @override
  String get classic => 'Classic';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get cancel => 'Cancel';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get darkModeSubtitle => 'Enable dark theme';

  @override
  String get audio => 'Audio';

  @override
  String get soundFx => 'Sound FX';

  @override
  String get soundFxSubtitle => 'Enable sound effects';

  @override
  String get animations => 'Animations';

  @override
  String get animationsSubtitle => 'Enable animations';

  @override
  String get language => 'Language';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get editUsername => 'Edit username';

  @override
  String get pleaseEnterUsername => 'Please enter a username';

  @override
  String get usernameMinLength => 'Username must contain at least 2 characters';

  @override
  String get usernameMaxLength => 'Username cannot exceed 20 characters';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get back => 'Back';

  @override
  String get reset => 'Restart';

  @override
  String get playerX => 'Player X';

  @override
  String get playerO => 'Player O';

  @override
  String get computer => 'AI';

  @override
  String get aiEasy => 'The Rookie';

  @override
  String get aiMedium => 'The Expert';

  @override
  String get aiHard => 'The Master';

  @override
  String get aiEasySubtitle => 'Perfect to start';

  @override
  String get aiMediumSubtitle => 'A real challenge';

  @override
  String get aiHardSubtitle => 'Almost unbeatable';

  @override
  String get waiting => 'Waiting...';

  @override
  String get playing => 'Playing';

  @override
  String get xWon => 'X wins!';

  @override
  String get oWon => 'O wins!';

  @override
  String get draw => 'Draw!';

  @override
  String get youWon => 'You won!';

  @override
  String playerWon(String player) {
    return '$player won!';
  }

  @override
  String get matchDraw => 'Match draw!';

  @override
  String get gameOver => 'Game over';

  @override
  String get playAgain => 'Play Again';

  @override
  String get newGameButton => 'New Game';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Code copied!';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get usernameUpdated => 'Username updated successfully';

  @override
  String get avatar => 'Avatar';

  @override
  String get editAvatar => 'Edit avatar';

  @override
  String get chooseAvatar => 'Choose Your Avatar';

  @override
  String chooseAvatarMessage(String username) {
    return 'Select an avatar for $username';
  }

  @override
  String get chooseAvatarForFriend => 'Choose an avatar for your friend';

  @override
  String get friendAvatar => 'Friend\'s Avatar';

  @override
  String get pleaseSelectAvatar => 'Please select an avatar';

  @override
  String get noAvatar => 'No avatar';

  @override
  String get avatarUpdated => 'Avatar updated successfully';

  @override
  String get continueButton => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get undefined => 'Non défini';

  @override
  String get about => 'About';

  @override
  String get thanksTestersMessage =>
      'Thanks to Julie, Eliott and Stéphane for user testing and valuable feedback.';

  @override
  String get collaborativeTicTacToe => 'XO Clash';

  @override
  String get chooseGameMode => 'Choose game mode';

  @override
  String get gameModeDescription => 'Select how you want to play';

  @override
  String get onlineMode => 'Online';

  @override
  String get onlineModeDescription => 'Play with friends online';

  @override
  String get offlineFriendMode => 'Local Friend';

  @override
  String get offlineFriendModeDescription =>
      'Play with a friend on the same device';

  @override
  String get offlineComputerMode => 'Computer';

  @override
  String get offlineComputerModeDescription => 'Play against the computer';

  @override
  String get chooseDifficulty => 'Choose difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get hard => 'Hard';

  @override
  String get enterFriendName => 'Enter friend\'s name';

  @override
  String get friendName => 'Friend\'s name';

  @override
  String get enterFriendNameHint => 'Enter your friend\'s name';

  @override
  String get logout => 'Logout';

  @override
  String get logoutSubtitle => 'Sign out and reset';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get statistics => 'Statistics';

  @override
  String get scores => 'Scores';

  @override
  String get history => 'History';

  @override
  String get wins => 'Wins';

  @override
  String get losses => 'Losses';

  @override
  String get draws => 'Draws';

  @override
  String get totalGames => 'Total Games';

  @override
  String get winRate => 'Win Rate';

  @override
  String get noScores => 'No scores recorded';

  @override
  String get noHistory => 'No history';

  @override
  String get player => 'Player';

  @override
  String get result => 'Result';

  @override
  String get date => 'Date';

  @override
  String get boardSize => 'Size';

  @override
  String get gameMode => 'Mode';

  @override
  String get online => 'Online';

  @override
  String get offlineFriend => 'Local Friend';

  @override
  String get offlineComputer => 'Computer';

  @override
  String get vs => 'vs';

  @override
  String get rank => 'Rank';

  @override
  String get winner => 'Winner';

  @override
  String get loser => 'Loser';

  @override
  String get yourTurn => 'Your Turn';

  @override
  String get hisTurn => 'His Turn';

  @override
  String get symbols => 'Symbols';

  @override
  String get symbolShapes => 'Symbol Shapes';

  @override
  String get customizeXAndO => 'Customize X and O';

  @override
  String get symbolsXAndO => 'Symbols X and O';

  @override
  String get shapes => 'Shapes';

  @override
  String get emojis => 'Emojis';

  @override
  String get shapeX => 'Shape X';

  @override
  String get shapeO => 'Shape O';

  @override
  String get emojiX => 'Emoji X';

  @override
  String get emojiO => 'Emoji O';

  @override
  String get resetSessionScores => 'Reset session scores';

  @override
  String get sessionScoresReset => 'Session scores reset';

  @override
  String get confirmSessionResetTitle => 'Delete all data?';

  @override
  String get confirmSessionResetMessage =>
      'This will delete all scores and history. This action cannot be undone.';

  @override
  String get allDataDeleted => 'All data deleted';

  @override
  String get confirm => 'Confirm';

  @override
  String get point => 'Point';

  @override
  String get points => 'Points';

  @override
  String get developedBy => 'Developed with ❤️ by Eric Vassille';

  @override
  String get emojiCategoryAnimals => 'Animals';

  @override
  String get emojiCategoryFood => 'Food';

  @override
  String get emojiCategoryObjects => 'Objects';

  @override
  String get emojiCategoryNature => 'Nature';

  @override
  String get emojiCategoryFaces => 'Faces';

  @override
  String get emojiCategorySports => 'Sports';

  @override
  String get componentLibrary => 'Component Library';

  @override
  String get searchComponents => 'Search...';

  @override
  String get viewReusableComponents => 'View reusable components';

  @override
  String get errorNetworkTimeout =>
      'Connection timeout. Please check your internet connection.';

  @override
  String get errorNetworkConnection =>
      'No internet connection. Please check your network settings.';

  @override
  String get errorNetworkGeneric =>
      'Network error occurred. Please try again later.';

  @override
  String get errorStoragePermission =>
      'Storage permission denied. Please check app permissions.';

  @override
  String get errorStorageQuota =>
      'Storage quota exceeded. Please free up some space.';

  @override
  String get errorStorageGeneric => 'Storage error occurred. Please try again.';

  @override
  String get errorAuthCancelled => 'Sign-in was cancelled.';

  @override
  String get errorAuthInvalid => 'Invalid credentials. Please try again.';

  @override
  String get errorAuthGeneric =>
      'Authentication error occurred. Please try again.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';
}
