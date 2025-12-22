/// Playbook strings - English only
///
/// Note: These strings are hardcoded because Playbook library doesn't
/// provide BuildContext in Story/Scenario titles, making it impossible
/// to use AppLocalizations (l10n) directly.
///
/// Playbook is a dev tool, keeping it in English only.
class PlaybookStrings {
  PlaybookStrings._();

  // Story names
  static const String gameButton = 'GameButton';
  static const String appLogo = 'AppLogo';
  static const String cosmicBackground = 'CosmicBackground';
  static const String avatarSelector = 'AvatarSelector';
  static const String modalBottomSheet = 'ModalBottomSheet';
  static const String emojiSelector = 'EmojiSelector';
  static const String shapeSelector = 'ShapeSelector';
  static const String confettiWidget = 'ConfettiWidget';
  static const String textFieldWithEmoji = 'TextField with Emoji Selector';
  static const String usernameTextField = 'UsernameTextField';
  static const String cards = 'Cards';
  static const String gameIdFormatter = 'GameIdTextFormatter';
  static const String joinGameSection = 'JoinGameSection';

  // Common scenario names
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String customSize = 'Custom Size';
  static const String noSelection = 'No Selection';
  static const String withContent = 'With Content';
  static const String defaultState = 'Default';
  static const String withPadding = 'With Padding';
  static const String narrowWidth = 'Narrow Width';
  static const String customColors = 'Custom Colors';
  static const String inactive = 'Inactive';

  // Button scenarios
  static const String defaultButton = 'Default Button';
  static const String primaryButton = 'Primary Button';
  static const String outlinedButton = 'Outlined Button';
  static const String buttonWithIcon = 'Button with Icon';
  static const String loadingButton = 'Loading Button';
  static const String disabledButton = 'Disabled Button';

  // Logo scenarios
  static const String xoClashTitle = 'XO Clash Title';
  static const String defaultTitle = 'Default Title';
  static const String customFontSize = 'Custom Font Size';

  // Background scenarios
  static const String darkBackground = 'Dark Background';
  static const String lightBackground = 'Light Background';

  // Modal scenarios
  static const String openModal = 'Open Modal';

  // Content scenarios

  // Shape scenarios
  static const String allShapesSelected = 'All Shapes Selected';

  // Confetti scenarios
  static const String activeConfetti = 'Active Confetti';
  static const String victory = 'Victory!';
  static const String noConfetti = 'No Confetti';

  // TextField scenarios
  static const String usernameFieldDark = 'Username Field with Emoji (Dark)';
  static const String usernameFieldLight = 'Username Field with Emoji (Light)';
  static const String gameIdField = 'Game ID Field with Clear Button';
  static const String searchField = 'Search Field';

  // UsernameTextField scenarios
  static const String defaultStateDark = 'Default State - Dark Mode';
  static const String defaultStateLight = 'Default State - Light Mode';
  static const String withTextDark = 'With Text - Dark Mode';
  static const String focusedState = 'Focused State';

  // Card scenarios
  static const String standardCardDark = 'Standard Card - Dark Mode';
  static const String standardCardLight = 'Standard Card - Light Mode';
  static const String cardWithElevation = 'Card with Elevation';
  static const String activeGameInfo = 'Active Game Info Card';
  static const String statisticsCard = 'Statistics Card with Rank';
  static const String gameIdCard = 'Game ID Card';
  static const String inactiveCard = 'Inactive Card';
  static const String infoCard = 'Info Card';

  // Formatter scenarios
  static const String formatterDemo = 'Formatter Demo';

  // JoinGameSection scenarios
  static const String withValidGameId = 'With Valid Game ID';

  // Button text examples
  static const String playGame = 'Play Game';
  static const String startGame = 'Start Game';
  static const String settings = 'Settings';
  static const String signIn = 'Sign In';
  static const String loading = 'Loading...';
  static const String disabled = 'Disabled';
  static const String custom = 'Custom';

  // Content examples
  static const String modalContent = 'Modal content goes here';
  static const String cardTitle = 'Card Title';
  static const String cardDescDark = 'This is a standard card in dark mode';
  static const String cardDescLight = 'This is a standard card in light mode';
  static const String elevatedCard = 'Elevated Card';
  static const String cardElevationDesc = 'This card has elevation for depth';
  static const String player1 = 'Player 1';
  static const String yourTurn = 'Your turn';
  static const String playerName = 'Player Name';
  static const String winsLosses = 'Wins: 10 | Losses: 2';
  static const String gameCodeLabel = 'Game Code';
  static const String player2 = 'Player 2';
  static const String waiting = 'Waiting...';
  static const String information = 'Information';
  static const String infoCardDesc =
      'This is an informational card that provides additional context or details to the user.';
  static const String gameIdFormatterTitle = 'Game ID Formatter';
  static const String enterGameCode = 'Enter Game Code';
  static const String typeExample = 'Type: abc123 or ABC123';
  static const String formatted = 'Formatted:';
  static const String formatterDesc =
      'Auto-uppercase, filters invalid chars, max 6 chars';
}
