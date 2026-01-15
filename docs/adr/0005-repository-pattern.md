# ADR-0005: Repository Pattern

## Status
Accepted

## Context
We need to abstract data access so business logic doesn't depend on concrete data sources (local storage, Firebase, etc.). Business logic should work regardless of where data comes from.

## Decision
We use the **Repository Pattern**:
- Repository interfaces defined in Domain layer (no dependencies)
- Repository implementations in Data layer (depend on Domain)
- Use cases depend on Repository interfaces, not implementations

### Structure
```
lib/features/{feature}/
├── domain/
│   └── repositories/
│       └── {feature}_repository.dart      # Interface (abstract)
└── data/
    └── repositories/
        └── {feature}_repository_impl.dart # Implementation
```

### Example
```dart
// Domain layer (no dependencies)
abstract class GameRepository {
  Future<GameState> createGame();
  Future<GameState> makeMove(GameState gameState, int row, int col);
  // ...
}

// Data layer (depends on Domain)
class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource localDataSource;
  final RemoteGameDataSource? remoteDataSource;

  // Implementation details...
}

// Provider in service_providers.dart
final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepositoryImpl(
    localDataSource: ref.watch(localGameDataSourceProvider),
    remoteDataSource: ref.watch(remoteGameDataSourceProvider),
    logger: ref.watch(loggerServiceProvider),
  ),
);

// Use case (depends on Domain interface)
class MakeMoveUseCase {
  final GameRepository repository;  // Interface, not implementation
  // ...
}
```

## Consequences

### Positive
- **Dependency Inversion**: Domain doesn't depend on Data
- **Testable**: Can mock repositories in use case tests
- **Flexible**: Can swap data sources without changing business logic
- **Clean Architecture**: Respects dependency rule

### Negative
- Additional abstraction layer (acceptable trade-off)
- Need to maintain interface contracts

### Notes
- Repositories coordinate between local and remote data sources
- Use cases only know about repository interfaces
