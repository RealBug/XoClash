# ADR-0003: Pure Riverpod Dependency Injection

## Status
Accepted

## Context
Dependency injection is needed for services and state management for UI. A hybrid approach (GetIt + Riverpod) adds complexity:

- Two DI systems to understand and maintain
- Wrapper providers to bridge GetIt → Riverpod
- Code generation with `injectable_generator`
- Additional dependencies (`get_it`, `injectable`, `injectable_generator`)

## Decision
We migrate to **pure Riverpod** for all dependency injection, eliminating GetIt and Injectable entirely.

### Architecture
All services, repositories, and data sources are now created directly via Riverpod providers:

```dart
// lib/core/providers/service_providers.dart

// Services
final loggerServiceProvider = Provider<LoggerService>(
  (ref) => LoggerServiceImpl(),
);

final audioServiceProvider = Provider<AudioService>(
  (ref) => AudioServiceImpl(ref.watch(loggerServiceProvider)),
);

// DataSources
final userDataSourceProvider = Provider<UserDataSource>(
  (ref) => UserDataSourceImpl(),
);

// Repositories
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(dataSource: ref.watch(userDataSourceProvider)),
);
```

### Centralized Provider File
All infrastructure providers are defined in `lib/core/providers/service_providers.dart`:
- Core services (Logger, Audio, AppInfo)
- All DataSources
- All Repositories
- Backend services (Firebase)

Feature-specific providers import from this central file.

## Consequences

### Positive
- **Simplicity**: Single DI system to understand
- **No code generation**: No need for `build_runner` for DI
- **Fewer dependencies**: Removed `get_it`, `injectable`, `injectable_generator`
- **Unified testing**: All providers testable via `ProviderContainer` overrides
- **Clear dependency graph**: Riverpod's `ref.watch()` makes dependencies explicit
- **Better IDE support**: Full autocomplete and navigation

### Negative
- Providers created at first access (not at app startup) - negligible impact
- Large provider file - mitigated by good organization

### Migration Summary

**Removed:**
- `lib/core/di/injection.dart`
- `lib/core/di/injection.config.dart`
- All `@Injectable`, `@LazySingleton`, `@factoryParam` annotations
- `get_it` and `injectable` from `pubspec.yaml`

**Modified:**
- `lib/core/providers/service_providers.dart` - central provider definitions
- All feature providers - removed `getIt<>()` calls
- `main.dart` - removed `configureDependencies()`
- Test files - removed GetIt setup/teardown

### Testing Pattern

```dart
// Before (GetIt)
setUpAll(() {
  setupTestGetIt();
});

// After (pure Riverpod)
late ProviderContainer container;

setUp(() {
  container = ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(mockUserRepository),
    ],
  );
});
```
