# ADR-0001: Feature-First Clean Architecture

## Status
Accepted

## Context
We need to organize a Flutter application with multiple features (auth, game, history, score, settings, user) while maintaining clean architecture principles. Traditional layer-first organization (all data layers together, all domain layers together) becomes hard to navigate as the codebase grows.

## Decision
We adopt a **Feature-First** architecture where code is organized by features rather than layers. Each feature is self-contained with its own data, domain, and presentation layers.

```
lib/features/{feature}/
├── data/                    # Data layer
│   ├── datasources/         # Data sources (local, remote)
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer (business logic)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   ├── strategies/          # Business strategies (e.g., AI strategies)
│   └── usecases/            # Use cases
└── presentation/            # Presentation layer
    ├── providers/           # Riverpod providers
    ├── screens/             # Feature screens
    └── widgets/             # Feature-specific widgets
```

## Consequences

### Positive
- **Modularity**: Each feature is independent and can be developed/tested in isolation
- **Scalability**: Easy to add new features without affecting existing ones
- **Team Collaboration**: Multiple developers can work on different features simultaneously
- **Maintainability**: Clear boundaries and responsibilities
- **Testability**: Features can be tested independently

### Negative
- Some code duplication across features (acceptable trade-off)
- Shared code must be carefully placed in `lib/core/`

### Notes
- Core/shared code lives in `lib/core/` (services, constants, widgets, theme)
- Each feature follows Clean Architecture layers within itself
- Domain layer has no dependencies (pure business logic)
- Data layer depends on Domain (implements domain interfaces)
- Presentation layer depends on Domain (uses use cases and entities)





