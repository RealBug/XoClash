# ADR-0004: Offline-First Approach

## Status
Accepted

## Context
We want the app to work offline (local friend mode, computer mode) and optionally sync online when Firebase is available. Users shouldn't need Firebase to use basic features.

## Decision
We implement an **offline-first** approach:
- Local storage (SharedPreferences) is the primary data source
- Remote sync (Firebase) is optional and lazy-loaded
- Offline modes work without any Firebase setup
- Online mode requires Firebase but gracefully degrades if unavailable

### Architecture
```
lib/features/{feature}/data/datasources/
├── local_{feature}_datasource.dart    # Always available (SharedPreferences)
└── remote_{feature}_datasource.dart   # Optional (depends on BackendService)
```

### Repository Pattern
Repositories check if remote is available and fallback to local:
```dart
class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource localDataSource;
  final RemoteGameDataSource? remoteDataSource;  // Optional
  
  Future<GameState> createGame() async {
    // Always save locally
    final game = await localDataSource.createGame();
    
    // Optionally sync remotely if available
    if (remoteDataSource != null && game.isOnline) {
      await remoteDataSource.createGame(game);
    }
    
    return game;
  }
}
```

## Consequences

### Positive
- **Works offline**: Core features don't require internet
- **Progressive enhancement**: Online features enhance but don't block
- **User-friendly**: No Firebase setup required for basic usage
- **Resilient**: App works even if Firebase is down

### Negative
- Need to handle sync conflicts (acceptable for this use case)
- More complex repository logic

### Notes
- Firebase services use lazy loading - initialized only when needed
- Offline modes (Local Friend, Computer) work without Firebase
- Online mode requires Firebase configuration (see `docs/FIREBASE_SETUP.md`)

