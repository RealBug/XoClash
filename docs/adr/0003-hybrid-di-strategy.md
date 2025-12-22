# ADR-0003: Hybrid Dependency Injection Strategy (GetIt + Riverpod)

## Status
Accepted

## Context
We need dependency injection for services and state management for UI. Using only GetIt makes state management harder. Using only Riverpod for everything mixes infrastructure concerns with UI state.

## Decision
We use a **hybrid approach**:
- **GetIt + Injectable**: For technical services and infrastructure components
- **Riverpod**: For state management and business logic

### GetIt Usage
- Services: `LoggerService`, `AudioService`, `AppInfoService`
- Data Sources: `LocalGameDataSource`, `RemoteGameDataSource`, etc.
- Repositories: `GameRepository`, `UserRepository`, `SettingsRepository`, etc.
- Backend Services: `FirebaseGameBackendService`, `FirebaseAuthBackendService`

### Riverpod Usage
- Notifiers: `GameStateNotifier`, `UserNotifier`, `SettingsNotifier`, etc.
- Providers: Wrapper providers that expose GetIt services to Riverpod
- Use Cases: Accessed via Riverpod providers

### Pattern
```dart
// Services in GetIt (annotated with @Injectable)
@LazySingleton(as: LoggerService)
class LoggerServiceImpl implements LoggerService { ... }

// Services exposed to Riverpod (via wrapper providers)
final loggerServiceProvider = Provider<LoggerService>(
  (ref) => getIt<LoggerService>(),
);

// Usage in Notifiers (always via Riverpod)
class UserNotifier extends Notifier<User?> {
  Future<void> _loadUser() async {
    final logger = ref.read(loggerServiceProvider);  // ✅ GOOD
    // final logger = getIt<LoggerService>();        // ❌ BAD
  }
}
```

## Consequences

### Positive
- **Separation of Concerns**: GetIt handles infrastructure, Riverpod handles UI state
- **Testability**: Services can be easily mocked in GetIt
- **State Management**: Riverpod's reactive state management for UI
- **Best of Both Worlds**: GetIt's compile-time safety + Riverpod's reactivity

### Negative
- Two DI systems to understand (acceptable trade-off)
- Need wrapper providers to bridge GetIt → Riverpod

### Rules
1. ✅ Use GetIt directly only in: `main.dart`, service implementations, test setup
2. ✅ Use Riverpod providers in: Notifiers, Widgets, Presentation layer
3. ❌ Never use GetIt directly in: Notifiers, Widgets, Presentation layer





