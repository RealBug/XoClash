import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tictac/core/constants/app_constants.dart';
import 'package:tictac/core/constants/language_codes.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

class SettingsJsonKeys {
  SettingsJsonKeys._();

  static const String isDarkMode = 'isDarkMode';
  static const String soundFxEnabled = 'soundFxEnabled';
  static const String soundEnabled = 'soundEnabled';
  static const String animationsEnabled = 'animationsEnabled';
  static const String languageCode = 'languageCode';
  static const String xShape = 'xShape';
  static const String oShape = 'oShape';
  static const String xEmoji = 'xEmoji';
  static const String oEmoji = 'oEmoji';
  static const String useEmojis = 'useEmojis';
}

@Freezed(toJson: true)
abstract class Settings with _$Settings {
  const factory Settings({
    @Default(true) @JsonKey(name: SettingsJsonKeys.isDarkMode) bool isDarkMode,
    @Default(true) @JsonKey(name: SettingsJsonKeys.soundFxEnabled) bool soundFxEnabled,
    @Default(true) @JsonKey(name: SettingsJsonKeys.animationsEnabled) bool animationsEnabled,
    @Default(LanguageCodes.defaultLanguage) @JsonKey(name: SettingsJsonKeys.languageCode) String languageCode,
    @Default(AppConstants.defaultShape) @JsonKey(name: SettingsJsonKeys.xShape) String xShape,
    @Default(AppConstants.defaultShape) @JsonKey(name: SettingsJsonKeys.oShape) String oShape,
    @JsonKey(name: SettingsJsonKeys.xEmoji) String? xEmoji,
    @JsonKey(name: SettingsJsonKeys.oEmoji) String? oEmoji,
    @Default(false) @JsonKey(name: SettingsJsonKeys.useEmojis) bool useEmojis,
  }) = _Settings;

  const Settings._();

  factory Settings.fromJson(Map<String, dynamic> json) {
    if (json.containsKey(SettingsJsonKeys.soundEnabled) && !json.containsKey(SettingsJsonKeys.soundFxEnabled)) {
      final bool oldSoundEnabled = json[SettingsJsonKeys.soundEnabled] as bool? ?? true;
      final Map<String, dynamic> migratedJson = Map<String, dynamic>.from(json);
      migratedJson[SettingsJsonKeys.soundFxEnabled] = oldSoundEnabled;
      migratedJson.remove(SettingsJsonKeys.soundEnabled);
      json = migratedJson;
    }
    return Settings(
      isDarkMode: json[SettingsJsonKeys.isDarkMode] as bool? ?? true,
      soundFxEnabled: json[SettingsJsonKeys.soundFxEnabled] as bool? ?? true,
      animationsEnabled: json[SettingsJsonKeys.animationsEnabled] as bool? ?? true,
      languageCode: json[SettingsJsonKeys.languageCode] as String? ?? LanguageCodes.defaultLanguage,
      xShape: json[SettingsJsonKeys.xShape] as String? ?? AppConstants.defaultShape,
      oShape: json[SettingsJsonKeys.oShape] as String? ?? AppConstants.defaultShape,
      xEmoji: json[SettingsJsonKeys.xEmoji] as String?,
      oEmoji: json[SettingsJsonKeys.oEmoji] as String?,
      useEmojis: json[SettingsJsonKeys.useEmojis] as bool? ?? false,
    );
  }
}
