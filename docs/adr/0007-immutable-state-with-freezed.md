# ADR-0007: Immutable State with Freezed

## Status
Accepted

## Context
We need immutable state objects for game state, user, settings, etc. Manual implementation of `copyWith`, `==`, `hashCode`, `toString` is error-prone and verbose.

## Decision
We use **Freezed** for immutable data classes:
- Domain entities use `@freezed` annotation
- Freezed generates `copyWith`, `==`, `hashCode`, `toString`
- Freezed also generates JSON serialization support

### Example
```dart
@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    required List<List<Player>> board,
    @Default(Player.x) Player currentPlayer,
    @Default(GameStatus.playing) GameStatus status,
    // ...
  }) = _GameState;
}
```

## Consequences

### Positive
- **Immutable**: State cannot be accidentally modified
- **Type-safe**: Compile-time safety with generated code
- **Less boilerplate**: No manual `copyWith`, `==`, etc.
- **JSON support**: Easy serialization/deserialization

### Negative
- Requires code generation (`build_runner`)
- Generated files need to be committed or regenerated

### Notes
- Run `flutter pub run build_runner build` after modifying `@freezed` classes
- Generated files: `*.freezed.dart`
- See `lib/features/game/domain/entities/game_state.dart` for GameState example

