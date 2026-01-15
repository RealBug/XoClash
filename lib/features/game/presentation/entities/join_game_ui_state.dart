import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_game_ui_state.freezed.dart';

@freezed
abstract class JoinGameUIState with _$JoinGameUIState {
  const factory JoinGameUIState({
    @Default(false) bool isLoading,
    String? error,
  }) = _JoinGameUIState;
}
