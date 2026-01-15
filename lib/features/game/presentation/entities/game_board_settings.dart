import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_board_settings.freezed.dart';

@freezed
abstract class GameBoardSettings with _$GameBoardSettings {
  const factory GameBoardSettings({
    required String xShape,
    required String oShape,
    String? xEmoji,
    String? oEmoji,
    @Default(false) bool useEmojis,
  }) = _GameBoardSettings;
}
