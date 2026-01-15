# ADR-0008: Coordinator Navigation Pattern

## Status
Accepted

## Context
Navigation logic was tightly coupled to views, violating Clean Architecture principles. Views directly called `AutoRouter` methods, making them hard to test and creating dependencies on routing implementation details.

## Decision
We implement a **Coordinator Pattern** for navigation using a Chain of Responsibility approach:

1. **NavigationService**: Abstract interface for navigation operations
2. **FlowEvents**: Sealed classes representing user intentions from the UI
3. **Coordinators**: Feature-specific coordinators that handle navigation events
4. **FlowCoordinator**: Central dispatcher that routes events to appropriate coordinators

### Architecture

```
┌─────────────┐
│    View     │
│  (Widget)   │
└──────┬──────┘
       │ emits FlowEvent
       ▼
┌─────────────────┐
│ FlowCoordinator │
└──────┬──────────┘
       │ dispatches to
       ▼
┌─────────────────────┐
│ Feature Coordinators │
│ - AuthCoordinator    │
│ - HomeCoordinator    │
│ - GameCoordinator    │
│ - OnboardingCoord... │
│ - NavigationCoord...│
└──────┬──────────────┘
       │ uses
       ▼
┌──────────────────┐
│ NavigationService │
└──────────────────┘
```

### Structure

```
lib/core/navigation/
├── coordinator.dart              # Base interface and class
├── flow_coordinator.dart         # Main dispatcher
├── flow_events.dart              # Navigation event definitions
└── coordinators/
    └── navigation_coordinator.dart  # General navigation (back, home, splash)

lib/features/
├── auth/navigation/
│   └── auth_coordinator.dart
├── game/navigation/
│   └── game_coordinator.dart
├── home/navigation/
│   └── home_coordinator.dart
└── onboarding/navigation/
    └── onboarding_coordinator.dart

lib/core/services/
├── navigation_service.dart       # Abstract interface
└── navigation_service_impl.dart  # AutoRouter implementation
```

**Note**: Coordinators are organized within their respective features following the feature-first architecture principle. This keeps navigation logic close to the feature it serves and improves maintainability.

### Example

**View emits event:**
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        navigate(ref, RequestNewGame());
      },
      child: Text('New Game'),
    );
  }
}
```

**FlowCoordinator dispatches:**
```dart
class FlowCoordinator {
  void handle(FlowEvent event) {
    for (final coordinator in _coordinators) {
      if (coordinator.canHandle(event)) {
        coordinator.handle(event);
        return;
      }
    }
  }
}
```

**Coordinator handles:**
```dart
class HomeCoordinator extends BaseCoordinator {
  @override
  bool canHandle(FlowEvent event) => event is RequestNewGame;

  @override
  void handle(FlowEvent event) {
    switch (event) {
      case RequestNewGame():
        navigation.toGameMode();
      // ...
    }
  }
}
```

## Consequences

### Positive
- **Decoupling**: Views don't know about routing implementation
- **Testability**: Coordinators are easily testable in isolation
- **Maintainability**: Navigation logic centralized per feature
- **Scalability**: Easy to add new coordinators without modifying existing ones
- **No God Class**: Chain of Responsibility avoids large switch statements
- **Type Safety**: Sealed classes ensure exhaustive pattern matching

### Negative
- Additional abstraction layer (acceptable trade-off)
- More files to maintain (but better organized)

### Notes
- Views emit `FlowEvent`s, never call navigation directly
- Each coordinator handles a subset of events for its feature
- `NavigationService` abstracts `AutoRouter` implementation
- All coordinators are fully tested
