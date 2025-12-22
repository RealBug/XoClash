import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// XO Clash - Jeu de morpion multijoueur
  ///
  /// In fr, this message translates to:
  /// **'XO Clash'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue !'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Défiez vos amis ou l\'IA, n\'importe quand, n\'importe où'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signup;

  /// No description provided for @welcomeBack.
  ///
  /// In fr, this message translates to:
  /// **'Content de te revoir !'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @enterUsernameToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi avec ton compte'**
  String get enterUsernameToLogin;

  /// No description provided for @playAsGuest.
  ///
  /// In fr, this message translates to:
  /// **'Jouer en invité'**
  String get playAsGuest;

  /// No description provided for @signupWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire avec Email'**
  String get signupWithEmail;

  /// No description provided for @signupWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire avec Google'**
  String get signupWithGoogle;

  /// No description provided for @signupWithApple.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire avec Apple'**
  String get signupWithApple;

  /// No description provided for @loginWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Email'**
  String get loginWithEmail;

  /// No description provided for @loginWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Google'**
  String get loginWithGoogle;

  /// No description provided for @loginWithApple.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Apple'**
  String get loginWithApple;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide'**
  String get invalidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton mot de passe'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get passwordMinLength;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton adresse email et nous t\'enverrons un lien pour réinitialiser ton mot de passe.'**
  String get forgotPasswordMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get sendResetLink;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Le lien de réinitialisation a été envoyé à ton email'**
  String get passwordResetEmailSent;

  /// No description provided for @enterEmail.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton email'**
  String get enterEmail;

  /// No description provided for @chooseUsername.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un pseudo pour commencer à jouer'**
  String get chooseUsername;

  /// Username label
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton pseudo'**
  String get enterUsername;

  /// No description provided for @start.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get start;

  /// Greeting message
  ///
  /// In fr, this message translates to:
  /// **'Prêt à jouer, {username} ?'**
  String hello(String username);

  /// No description provided for @playOnline.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton adversaire et c\'est parti !'**
  String get playOnline;

  /// No description provided for @newGame.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Partie'**
  String get newGame;

  /// No description provided for @or.
  ///
  /// In fr, this message translates to:
  /// **'OU'**
  String get or;

  /// No description provided for @joinGame.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get joinGame;

  /// No description provided for @gameCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de la partie'**
  String get gameCode;

  /// No description provided for @enterGameCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de la partie'**
  String get enterGameCode;

  /// No description provided for @gameNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Partie introuvable. Vérifiez le code et réessayez.'**
  String get gameNotFound;

  /// No description provided for @failedToJoinGame.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion à la partie. Veuillez réessayer.'**
  String get failedToJoinGame;

  /// No description provided for @invalidGameCode.
  ///
  /// In fr, this message translates to:
  /// **'Format de code de partie invalide'**
  String get invalidGameCode;

  /// No description provided for @chooseBoardSize.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la taille de la grille'**
  String get chooseBoardSize;

  /// No description provided for @winCondition.
  ///
  /// In fr, this message translates to:
  /// **'Pour gagner, alignez 3 symboles consécutifs\n(horizontal, vertical ou diagonal)'**
  String get winCondition;

  /// No description provided for @winCondition4.
  ///
  /// In fr, this message translates to:
  /// **'Pour gagner, alignez 4 symboles consécutifs\n(horizontal, vertical ou diagonal)'**
  String get winCondition4;

  /// No description provided for @threeInARow.
  ///
  /// In fr, this message translates to:
  /// **'3 symboles alignés pour gagner'**
  String get threeInARow;

  /// No description provided for @fourInARow.
  ///
  /// In fr, this message translates to:
  /// **'4 symboles alignés pour gagner'**
  String get fourInARow;

  /// No description provided for @classic.
  ///
  /// In fr, this message translates to:
  /// **'Classique'**
  String get classic;

  /// No description provided for @medium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In fr, this message translates to:
  /// **'Grand'**
  String get large;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @appearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activer le thème sombre'**
  String get darkModeSubtitle;

  /// No description provided for @audio.
  ///
  /// In fr, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @soundFx.
  ///
  /// In fr, this message translates to:
  /// **'Effets sonores'**
  String get soundFx;

  /// No description provided for @soundFxSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activer les effets sonores'**
  String get soundFxSubtitle;

  /// No description provided for @animations.
  ///
  /// In fr, this message translates to:
  /// **'Animations'**
  String get animations;

  /// No description provided for @animationsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Activer les animations'**
  String get animationsSubtitle;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @editUsername.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le pseudo'**
  String get editUsername;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer un pseudo'**
  String get pleaseEnterUsername;

  /// No description provided for @usernameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le pseudo doit contenir au moins 2 caractères'**
  String get usernameMinLength;

  /// No description provided for @usernameMaxLength.
  ///
  /// In fr, this message translates to:
  /// **'Le pseudo ne peut pas dépasser 20 caractères'**
  String get usernameMaxLength;

  /// Error message
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {message}'**
  String error(String message);

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get reset;

  /// No description provided for @playerX.
  ///
  /// In fr, this message translates to:
  /// **'Joueur X'**
  String get playerX;

  /// No description provided for @playerO.
  ///
  /// In fr, this message translates to:
  /// **'Joueur O'**
  String get playerO;

  /// No description provided for @computer.
  ///
  /// In fr, this message translates to:
  /// **'IA'**
  String get computer;

  /// No description provided for @aiEasy.
  ///
  /// In fr, this message translates to:
  /// **'Le Rookie'**
  String get aiEasy;

  /// No description provided for @aiMedium.
  ///
  /// In fr, this message translates to:
  /// **'L\'Expert'**
  String get aiMedium;

  /// No description provided for @aiHard.
  ///
  /// In fr, this message translates to:
  /// **'Le Maître'**
  String get aiHard;

  /// No description provided for @aiEasySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Parfait pour commencer'**
  String get aiEasySubtitle;

  /// No description provided for @aiMediumSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un vrai défi'**
  String get aiMediumSubtitle;

  /// No description provided for @aiHardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Presque imbattable'**
  String get aiHardSubtitle;

  /// No description provided for @waiting.
  ///
  /// In fr, this message translates to:
  /// **'En attente...'**
  String get waiting;

  /// No description provided for @playing.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get playing;

  /// No description provided for @xWon.
  ///
  /// In fr, this message translates to:
  /// **'X gagne !'**
  String get xWon;

  /// No description provided for @oWon.
  ///
  /// In fr, this message translates to:
  /// **'O gagne !'**
  String get oWon;

  /// No description provided for @draw.
  ///
  /// In fr, this message translates to:
  /// **'Égalité !'**
  String get draw;

  /// No description provided for @youWon.
  ///
  /// In fr, this message translates to:
  /// **'Tu as gagné !'**
  String get youWon;

  /// Player won message
  ///
  /// In fr, this message translates to:
  /// **'{player} a gagné !'**
  String playerWon(String player);

  /// No description provided for @matchDraw.
  ///
  /// In fr, this message translates to:
  /// **'Match nul !'**
  String get matchDraw;

  /// No description provided for @gameOver.
  ///
  /// In fr, this message translates to:
  /// **'Partie terminée'**
  String get gameOver;

  /// No description provided for @playAgain.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get playAgain;

  /// No description provided for @newGameButton.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Partie'**
  String get newGameButton;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In fr, this message translates to:
  /// **'Code copié !'**
  String get copied;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @usernameUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo modifié avec succès'**
  String get usernameUpdated;

  /// No description provided for @avatar.
  ///
  /// In fr, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @editAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'avatar'**
  String get editAvatar;

  /// No description provided for @chooseAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton avatar'**
  String get chooseAvatar;

  /// Message pour choisir l'avatar
  ///
  /// In fr, this message translates to:
  /// **'Sélectionne un avatar pour {username}'**
  String chooseAvatarMessage(String username);

  /// No description provided for @chooseAvatarForFriend.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un avatar pour ton ami'**
  String get chooseAvatarForFriend;

  /// No description provided for @friendAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Avatar de l\'ami'**
  String get friendAvatar;

  /// No description provided for @pleaseSelectAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner un avatar'**
  String get pleaseSelectAvatar;

  /// No description provided for @noAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avatar'**
  String get noAvatar;

  /// No description provided for @avatarUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Avatar modifié avec succès'**
  String get avatarUpdated;

  /// No description provided for @continueButton.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueButton;

  /// No description provided for @skip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get skip;

  /// No description provided for @undefined.
  ///
  /// In fr, this message translates to:
  /// **'Non défini'**
  String get undefined;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @thanksTestersMessage.
  ///
  /// In fr, this message translates to:
  /// **'Merci à Julie, Eliott et Stéphane pour les tests utilisateurs et retours précieux.'**
  String get thanksTestersMessage;

  /// No description provided for @collaborativeTicTacToe.
  ///
  /// In fr, this message translates to:
  /// **'XO Clash'**
  String get collaborativeTicTacToe;

  /// No description provided for @chooseGameMode.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le mode de jeu'**
  String get chooseGameMode;

  /// No description provided for @gameModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionne comment tu veux jouer'**
  String get gameModeDescription;

  /// No description provided for @onlineMode.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get onlineMode;

  /// No description provided for @onlineModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Jouer avec des amis en ligne'**
  String get onlineModeDescription;

  /// No description provided for @offlineFriendMode.
  ///
  /// In fr, this message translates to:
  /// **'Ami local'**
  String get offlineFriendMode;

  /// No description provided for @offlineFriendModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Jouer avec un ami sur le même appareil'**
  String get offlineFriendModeDescription;

  /// No description provided for @offlineComputerMode.
  ///
  /// In fr, this message translates to:
  /// **'Ordinateur'**
  String get offlineComputerMode;

  /// No description provided for @offlineComputerModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Jouer contre l\'ordinateur'**
  String get offlineComputerModeDescription;

  /// No description provided for @chooseDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la difficulté'**
  String get chooseDifficulty;

  /// No description provided for @easy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get easy;

  /// No description provided for @hard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get hard;

  /// No description provided for @enterFriendName.
  ///
  /// In fr, this message translates to:
  /// **'Entrer le nom de l\'ami'**
  String get enterFriendName;

  /// No description provided for @friendName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'ami'**
  String get friendName;

  /// No description provided for @enterFriendNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entre le nom de ton ami'**
  String get enterFriendNameHint;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @logoutSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter et réinitialiser'**
  String get logoutSubtitle;

  /// No description provided for @logoutConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr de vouloir te déconnecter ?'**
  String get logoutConfirmation;

  /// No description provided for @statistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statistics;

  /// No description provided for @scores.
  ///
  /// In fr, this message translates to:
  /// **'Scores'**
  String get scores;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @wins.
  ///
  /// In fr, this message translates to:
  /// **'Victoires'**
  String get wins;

  /// No description provided for @losses.
  ///
  /// In fr, this message translates to:
  /// **'Défaites'**
  String get losses;

  /// No description provided for @draws.
  ///
  /// In fr, this message translates to:
  /// **'Égalités'**
  String get draws;

  /// No description provided for @totalGames.
  ///
  /// In fr, this message translates to:
  /// **'Parties totales'**
  String get totalGames;

  /// No description provided for @winRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de victoire'**
  String get winRate;

  /// No description provided for @noScores.
  ///
  /// In fr, this message translates to:
  /// **'Aucun score enregistré'**
  String get noScores;

  /// No description provided for @noHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun historique'**
  String get noHistory;

  /// No description provided for @player.
  ///
  /// In fr, this message translates to:
  /// **'Joueur'**
  String get player;

  /// No description provided for @result.
  ///
  /// In fr, this message translates to:
  /// **'Résultat'**
  String get result;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @boardSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille'**
  String get boardSize;

  /// No description provided for @gameMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get gameMode;

  /// No description provided for @online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get online;

  /// No description provided for @offlineFriend.
  ///
  /// In fr, this message translates to:
  /// **'Ami local'**
  String get offlineFriend;

  /// No description provided for @offlineComputer.
  ///
  /// In fr, this message translates to:
  /// **'Ordinateur'**
  String get offlineComputer;

  /// No description provided for @vs.
  ///
  /// In fr, this message translates to:
  /// **'vs'**
  String get vs;

  /// No description provided for @rank.
  ///
  /// In fr, this message translates to:
  /// **'Rang'**
  String get rank;

  /// No description provided for @winner.
  ///
  /// In fr, this message translates to:
  /// **'Gagnant'**
  String get winner;

  /// No description provided for @loser.
  ///
  /// In fr, this message translates to:
  /// **'Perdant'**
  String get loser;

  /// No description provided for @yourTurn.
  ///
  /// In fr, this message translates to:
  /// **'Ton tour'**
  String get yourTurn;

  /// No description provided for @hisTurn.
  ///
  /// In fr, this message translates to:
  /// **'Son tour'**
  String get hisTurn;

  /// No description provided for @symbols.
  ///
  /// In fr, this message translates to:
  /// **'Symboles'**
  String get symbols;

  /// No description provided for @symbolShapes.
  ///
  /// In fr, this message translates to:
  /// **'Formes des symboles'**
  String get symbolShapes;

  /// No description provided for @customizeXAndO.
  ///
  /// In fr, this message translates to:
  /// **'Personnaliser X et O'**
  String get customizeXAndO;

  /// No description provided for @symbolsXAndO.
  ///
  /// In fr, this message translates to:
  /// **'Symboles X et O'**
  String get symbolsXAndO;

  /// No description provided for @shapes.
  ///
  /// In fr, this message translates to:
  /// **'Formes'**
  String get shapes;

  /// No description provided for @emojis.
  ///
  /// In fr, this message translates to:
  /// **'Emojis'**
  String get emojis;

  /// No description provided for @shapeX.
  ///
  /// In fr, this message translates to:
  /// **'Forme X'**
  String get shapeX;

  /// No description provided for @shapeO.
  ///
  /// In fr, this message translates to:
  /// **'Forme O'**
  String get shapeO;

  /// No description provided for @emojiX.
  ///
  /// In fr, this message translates to:
  /// **'Emoji X'**
  String get emojiX;

  /// No description provided for @emojiO.
  ///
  /// In fr, this message translates to:
  /// **'Emoji O'**
  String get emojiO;

  /// No description provided for @resetSessionScores.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser les scores de session'**
  String get resetSessionScores;

  /// No description provided for @sessionScoresReset.
  ///
  /// In fr, this message translates to:
  /// **'Scores de session réinitialisés'**
  String get sessionScoresReset;

  /// No description provided for @confirmSessionResetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer toutes les données ?'**
  String get confirmSessionResetTitle;

  /// No description provided for @confirmSessionResetMessage.
  ///
  /// In fr, this message translates to:
  /// **'Cela supprimera tous les scores et l\'historique. Cette action est irréversible.'**
  String get confirmSessionResetMessage;

  /// No description provided for @allDataDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les données supprimées'**
  String get allDataDeleted;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @point.
  ///
  /// In fr, this message translates to:
  /// **'Point'**
  String get point;

  /// No description provided for @points.
  ///
  /// In fr, this message translates to:
  /// **'Points'**
  String get points;

  /// Developer credit message
  ///
  /// In fr, this message translates to:
  /// **'Développé avec ❤️ par Eric Vassille'**
  String get developedBy;

  /// No description provided for @emojiCategoryAnimals.
  ///
  /// In fr, this message translates to:
  /// **'Animaux'**
  String get emojiCategoryAnimals;

  /// No description provided for @emojiCategoryFood.
  ///
  /// In fr, this message translates to:
  /// **'Nourriture'**
  String get emojiCategoryFood;

  /// No description provided for @emojiCategoryObjects.
  ///
  /// In fr, this message translates to:
  /// **'Objets'**
  String get emojiCategoryObjects;

  /// No description provided for @emojiCategoryNature.
  ///
  /// In fr, this message translates to:
  /// **'Nature'**
  String get emojiCategoryNature;

  /// No description provided for @emojiCategoryFaces.
  ///
  /// In fr, this message translates to:
  /// **'Visages'**
  String get emojiCategoryFaces;

  /// No description provided for @emojiCategorySports.
  ///
  /// In fr, this message translates to:
  /// **'Sports'**
  String get emojiCategorySports;

  /// No description provided for @componentLibrary.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque de composants'**
  String get componentLibrary;

  /// No description provided for @searchComponents.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get searchComponents;

  /// No description provided for @viewReusableComponents.
  ///
  /// In fr, this message translates to:
  /// **'Voir les composants réutilisables'**
  String get viewReusableComponents;

  /// No description provided for @errorNetworkTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Délai de connexion dépassé. Veuillez vérifier votre connexion internet.'**
  String get errorNetworkTimeout;

  /// No description provided for @errorNetworkConnection.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet. Veuillez vérifier vos paramètres réseau.'**
  String get errorNetworkConnection;

  /// No description provided for @errorNetworkGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur réseau s\'est produite. Veuillez réessayer plus tard.'**
  String get errorNetworkGeneric;

  /// No description provided for @errorStoragePermission.
  ///
  /// In fr, this message translates to:
  /// **'Permission de stockage refusée. Veuillez vérifier les permissions de l\'application.'**
  String get errorStoragePermission;

  /// No description provided for @errorStorageQuota.
  ///
  /// In fr, this message translates to:
  /// **'Quota de stockage dépassé. Veuillez libérer de l\'espace.'**
  String get errorStorageQuota;

  /// No description provided for @errorStorageGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur de stockage s\'est produite. Veuillez réessayer.'**
  String get errorStorageGeneric;

  /// No description provided for @errorAuthCancelled.
  ///
  /// In fr, this message translates to:
  /// **'La connexion a été annulée.'**
  String get errorAuthCancelled;

  /// No description provided for @errorAuthInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Identifiants invalides. Veuillez réessayer.'**
  String get errorAuthInvalid;

  /// No description provided for @errorAuthGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur d\'authentification s\'est produite. Veuillez réessayer.'**
  String get errorAuthGeneric;

  /// No description provided for @errorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue s\'est produite. Veuillez réessayer.'**
  String get errorUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
