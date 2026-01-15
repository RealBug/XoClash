# ADR-0006: Use Case Pattern

## Status
Accepted

## Context
We need to encapsulate business logic in a way that's testable, reusable, and independent of UI. Business rules should be isolated from presentation concerns.

## Decision
We use the **Use Case Pattern** to encapsulate business logic:
- Each use case represents a single business operation
- Use cases depend on Repository interfaces (not implementations)
- Use cases are pure business logic (no UI dependencies)
- Use cases are accessed via Riverpod providers

### Structure
```
lib/features/{feature}/domain/usecases/
├── create_{feature}_usecase.dart
├── get_{feature}_usecase.dart
├── update_{feature}_usecase.dart
└── delete_{feature}_usecase.dart
```

### Example
```dart
class MakeMoveUseCase {
  final GameRepository repository;

  MakeMoveUseCase(this.repository);

  Future<GameState> execute(GameState gameState, int row, int col) async {
    // Business logic: validate move
    if (gameState.board[row][col] != Player.none) {
      return gameState;  // Invalid move
    }

    if (gameState.isGameOver) {
      return gameState;  // Game already over
    }

    // Delegate to repository
    return await repository.makeMove(gameState, row, col);
  }
}
```

## Consequences

### Positive
- **Single Responsibility**: Each use case does one thing
- **Testable**: Easy to test business logic in isolation
- **Reusable**: Same use case can be used from different UIs
- **Clean**: Business logic separated from UI and data access
- **Enforced Architecture**: All providers must use use cases (no direct repository calls)

### Negative
- More files/classes (acceptable trade-off)
- Need to coordinate multiple use cases for complex operations

### Notes
- Use cases are accessed via Riverpod providers in Notifiers
- Use cases contain business rules and validation
- Use cases delegate data operations to repositories
- **Architecture Rule**: Providers MUST use use cases, NEVER call repositories directly
- **Dependency Injection**: Use cases receive dependencies via Riverpod providers. Dependencies are required parameters (not nullable with defaults) unless explicitly needed for testing with mocks

### Examples

**User Management:**
```dart
// UpdateUsernameUseCase - Preserves email and avatar
class UpdateUsernameUseCase {
  final UserRepository _userRepository;

  Future<User> execute(User? currentUser, String newUsername) async {
    final trimmedUsername = newUsername.trim();
    final updatedUser = User(
      username: trimmedUsername,
      email: currentUser?.email,  // Preserve
      avatar: currentUser?.avatar, // Preserve
    );
    await _userRepository.saveUser(updatedUser);
    return updatedUser;
  }
}
```

**Settings Management:**
```dart
// SetLanguageUseCase - Encapsulates language change logic
class SetLanguageUseCase {
  final SettingsRepository _repository;

  Future<void> execute(String languageCode) async {
    final currentSettings = await _repository.getSettings();
    final updatedSettings = currentSettings.copyWith(languageCode: languageCode);
    await _repository.saveSettings(updatedSettings);
  }
}
```

**Provider Usage:**
```dart
// ✅ GOOD: Use case via provider
class UserNotifier extends AsyncNotifier<User?> {
  Future<void> updateUsername(String newUsername) async {
    final currentUser = state.value;
    final updatedUser = await updateUsernameUseCase.execute(currentUser, newUsername);
    state = AsyncData(updatedUser);
  }
}

// ❌ BAD: Direct repository call (violates architecture)
class UserNotifier extends AsyncNotifier<User?> {
  Future<void> updateUsername(String newUsername) async {
    // DON'T DO THIS - violates Clean Architecture
    await userRepository.saveUser(...);
  }
}
```
