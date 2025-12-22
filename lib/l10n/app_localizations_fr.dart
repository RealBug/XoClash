// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'XO Clash';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get welcomeMessage =>
      'Défiez vos amis ou l\'IA, n\'importe quand, n\'importe où';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'Inscription';

  @override
  String get welcomeBack => 'Content de te revoir !';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get enterUsernameToLogin => 'Connecte-toi avec ton compte';

  @override
  String get playAsGuest => 'Jouer en invité';

  @override
  String get signupWithEmail => 'S\'inscrire avec Email';

  @override
  String get signupWithGoogle => 'S\'inscrire avec Google';

  @override
  String get signupWithApple => 'S\'inscrire avec Apple';

  @override
  String get loginWithEmail => 'Se connecter avec Email';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get loginWithApple => 'Se connecter avec Apple';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get pleaseEnterEmail => 'Entre ton email';

  @override
  String get invalidEmail => 'Adresse email invalide';

  @override
  String get pleaseEnterPassword => 'Entre ton mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordMessage =>
      'Entre ton adresse email et nous t\'enverrons un lien pour réinitialiser ton mot de passe.';

  @override
  String get sendResetLink => 'Envoyer le lien';

  @override
  String get passwordResetEmailSent =>
      'Le lien de réinitialisation a été envoyé à ton email';

  @override
  String get enterEmail => 'Entre ton email';

  @override
  String get chooseUsername => 'Choisissez un pseudo pour commencer à jouer';

  @override
  String get username => 'Pseudo';

  @override
  String get enterUsername => 'Entre ton pseudo';

  @override
  String get start => 'Commencer';

  @override
  String hello(String username) {
    return 'Prêt à jouer, $username ?';
  }

  @override
  String get playOnline => 'Choisis ton adversaire et c\'est parti !';

  @override
  String get newGame => 'Nouvelle Partie';

  @override
  String get or => 'OU';

  @override
  String get joinGame => 'Rejoindre';

  @override
  String get gameCode => 'Code de la partie';

  @override
  String get enterGameCode => 'Code de la partie';

  @override
  String get gameNotFound =>
      'Partie introuvable. Vérifiez le code et réessayez.';

  @override
  String get failedToJoinGame =>
      'Échec de la connexion à la partie. Veuillez réessayer.';

  @override
  String get invalidGameCode => 'Format de code de partie invalide';

  @override
  String get chooseBoardSize => 'Choisir la taille de la grille';

  @override
  String get winCondition =>
      'Pour gagner, alignez 3 symboles consécutifs\n(horizontal, vertical ou diagonal)';

  @override
  String get winCondition4 =>
      'Pour gagner, alignez 4 symboles consécutifs\n(horizontal, vertical ou diagonal)';

  @override
  String get threeInARow => '3 symboles alignés pour gagner';

  @override
  String get fourInARow => '4 symboles alignés pour gagner';

  @override
  String get classic => 'Classique';

  @override
  String get medium => 'Moyen';

  @override
  String get large => 'Grand';

  @override
  String get cancel => 'Annuler';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get appearance => 'Apparence';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get darkModeSubtitle => 'Activer le thème sombre';

  @override
  String get audio => 'Audio';

  @override
  String get soundFx => 'Effets sonores';

  @override
  String get soundFxSubtitle => 'Activer les effets sonores';

  @override
  String get animations => 'Animations';

  @override
  String get animationsSubtitle => 'Activer les animations';

  @override
  String get language => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get editUsername => 'Modifier le pseudo';

  @override
  String get pleaseEnterUsername => 'Veuillez entrer un pseudo';

  @override
  String get usernameMinLength =>
      'Le pseudo doit contenir au moins 2 caractères';

  @override
  String get usernameMaxLength =>
      'Le pseudo ne peut pas dépasser 20 caractères';

  @override
  String error(String message) {
    return 'Erreur: $message';
  }

  @override
  String get back => 'Retour';

  @override
  String get reset => 'Recommencer';

  @override
  String get playerX => 'Joueur X';

  @override
  String get playerO => 'Joueur O';

  @override
  String get computer => 'IA';

  @override
  String get aiEasy => 'Le Rookie';

  @override
  String get aiMedium => 'L\'Expert';

  @override
  String get aiHard => 'Le Maître';

  @override
  String get aiEasySubtitle => 'Parfait pour commencer';

  @override
  String get aiMediumSubtitle => 'Un vrai défi';

  @override
  String get aiHardSubtitle => 'Presque imbattable';

  @override
  String get waiting => 'En attente...';

  @override
  String get playing => 'En cours';

  @override
  String get xWon => 'X gagne !';

  @override
  String get oWon => 'O gagne !';

  @override
  String get draw => 'Égalité !';

  @override
  String get youWon => 'Tu as gagné !';

  @override
  String playerWon(String player) {
    return '$player a gagné !';
  }

  @override
  String get matchDraw => 'Match nul !';

  @override
  String get gameOver => 'Partie terminée';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get newGameButton => 'Nouvelle Partie';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Code copié !';

  @override
  String get share => 'Partager';

  @override
  String get save => 'Enregistrer';

  @override
  String get usernameUpdated => 'Pseudo modifié avec succès';

  @override
  String get avatar => 'Avatar';

  @override
  String get editAvatar => 'Modifier l\'avatar';

  @override
  String get chooseAvatar => 'Choisis ton avatar';

  @override
  String chooseAvatarMessage(String username) {
    return 'Sélectionne un avatar pour $username';
  }

  @override
  String get chooseAvatarForFriend => 'Choisis un avatar pour ton ami';

  @override
  String get friendAvatar => 'Avatar de l\'ami';

  @override
  String get pleaseSelectAvatar => 'Veuillez sélectionner un avatar';

  @override
  String get noAvatar => 'Aucun avatar';

  @override
  String get avatarUpdated => 'Avatar modifié avec succès';

  @override
  String get continueButton => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get undefined => 'Non défini';

  @override
  String get about => 'À propos';

  @override
  String get thanksTestersMessage =>
      'Merci à Julie, Eliott et Stéphane pour les tests utilisateurs et retours précieux.';

  @override
  String get collaborativeTicTacToe => 'XO Clash';

  @override
  String get chooseGameMode => 'Choisir le mode de jeu';

  @override
  String get gameModeDescription => 'Sélectionne comment tu veux jouer';

  @override
  String get onlineMode => 'En ligne';

  @override
  String get onlineModeDescription => 'Jouer avec des amis en ligne';

  @override
  String get offlineFriendMode => 'Ami local';

  @override
  String get offlineFriendModeDescription =>
      'Jouer avec un ami sur le même appareil';

  @override
  String get offlineComputerMode => 'Ordinateur';

  @override
  String get offlineComputerModeDescription => 'Jouer contre l\'ordinateur';

  @override
  String get chooseDifficulty => 'Choisir la difficulté';

  @override
  String get easy => 'Facile';

  @override
  String get hard => 'Difficile';

  @override
  String get enterFriendName => 'Entrer le nom de l\'ami';

  @override
  String get friendName => 'Nom de l\'ami';

  @override
  String get enterFriendNameHint => 'Entre le nom de ton ami';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutSubtitle => 'Se déconnecter et réinitialiser';

  @override
  String get logoutConfirmation => 'Es-tu sûr de vouloir te déconnecter ?';

  @override
  String get statistics => 'Statistiques';

  @override
  String get scores => 'Scores';

  @override
  String get history => 'Historique';

  @override
  String get wins => 'Victoires';

  @override
  String get losses => 'Défaites';

  @override
  String get draws => 'Égalités';

  @override
  String get totalGames => 'Parties totales';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String get noScores => 'Aucun score enregistré';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get player => 'Joueur';

  @override
  String get result => 'Résultat';

  @override
  String get date => 'Date';

  @override
  String get boardSize => 'Taille';

  @override
  String get gameMode => 'Mode';

  @override
  String get online => 'En ligne';

  @override
  String get offlineFriend => 'Ami local';

  @override
  String get offlineComputer => 'Ordinateur';

  @override
  String get vs => 'vs';

  @override
  String get rank => 'Rang';

  @override
  String get winner => 'Gagnant';

  @override
  String get loser => 'Perdant';

  @override
  String get yourTurn => 'Ton tour';

  @override
  String get hisTurn => 'Son tour';

  @override
  String get symbols => 'Symboles';

  @override
  String get symbolShapes => 'Formes des symboles';

  @override
  String get customizeXAndO => 'Personnaliser X et O';

  @override
  String get symbolsXAndO => 'Symboles X et O';

  @override
  String get shapes => 'Formes';

  @override
  String get emojis => 'Emojis';

  @override
  String get shapeX => 'Forme X';

  @override
  String get shapeO => 'Forme O';

  @override
  String get emojiX => 'Emoji X';

  @override
  String get emojiO => 'Emoji O';

  @override
  String get resetSessionScores => 'Réinitialiser les scores de session';

  @override
  String get sessionScoresReset => 'Scores de session réinitialisés';

  @override
  String get confirmSessionResetTitle => 'Supprimer toutes les données ?';

  @override
  String get confirmSessionResetMessage =>
      'Cela supprimera tous les scores et l\'historique. Cette action est irréversible.';

  @override
  String get allDataDeleted => 'Toutes les données supprimées';

  @override
  String get confirm => 'Confirmer';

  @override
  String get point => 'Point';

  @override
  String get points => 'Points';

  @override
  String get developedBy => 'Développé avec ❤️ par Eric Vassille';

  @override
  String get emojiCategoryAnimals => 'Animaux';

  @override
  String get emojiCategoryFood => 'Nourriture';

  @override
  String get emojiCategoryObjects => 'Objets';

  @override
  String get emojiCategoryNature => 'Nature';

  @override
  String get emojiCategoryFaces => 'Visages';

  @override
  String get emojiCategorySports => 'Sports';

  @override
  String get componentLibrary => 'Bibliothèque de composants';

  @override
  String get searchComponents => 'Rechercher...';

  @override
  String get viewReusableComponents => 'Voir les composants réutilisables';

  @override
  String get errorNetworkTimeout =>
      'Délai de connexion dépassé. Veuillez vérifier votre connexion internet.';

  @override
  String get errorNetworkConnection =>
      'Pas de connexion internet. Veuillez vérifier vos paramètres réseau.';

  @override
  String get errorNetworkGeneric =>
      'Une erreur réseau s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get errorStoragePermission =>
      'Permission de stockage refusée. Veuillez vérifier les permissions de l\'application.';

  @override
  String get errorStorageQuota =>
      'Quota de stockage dépassé. Veuillez libérer de l\'espace.';

  @override
  String get errorStorageGeneric =>
      'Une erreur de stockage s\'est produite. Veuillez réessayer.';

  @override
  String get errorAuthCancelled => 'La connexion a été annulée.';

  @override
  String get errorAuthInvalid => 'Identifiants invalides. Veuillez réessayer.';

  @override
  String get errorAuthGeneric =>
      'Une erreur d\'authentification s\'est produite. Veuillez réessayer.';

  @override
  String get errorUnknown =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer.';
}
