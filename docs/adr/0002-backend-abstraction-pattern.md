# ADR-0002: Backend Abstraction Pattern

## Status
Accepted

## Context
We need to support Firebase for online features (authentication, real-time game sync) but want the ability to switch backends or support multiple backends. Direct dependency on Firebase SDKs throughout the codebase would make this impossible.

## Decision
We use **abstract backend service interfaces** that concrete implementations (Firebase, Supabase, etc.) implement. Data sources depend on these abstract interfaces, not concrete implementations.

### Architecture
```
lib/features/{feature}/data/services/
├── {feature}_backend_service.dart      # Abstract interface
└── firebase_{feature}_backend_service.dart  # Firebase implementation
```

### Example: Auth
```dart
abstract class AuthBackendService {
  Future<AuthResult> signInAnonymously();
  Future<AuthResult> signInWithGoogle();
  Future<AuthResult> signInWithApple();
  // ...
}

@Injectable(as: AuthBackendService)
class FirebaseAuthBackendService implements AuthBackendService {
  // Firebase-specific implementation
}
```

## Consequences

### Positive
- **Backend-agnostic**: Easy to replace Firebase with another backend
- **Testable**: Can mock backend services in tests
- **Flexible**: Can support multiple backends simultaneously
- **Clean separation**: Business logic doesn't know about Firebase

### Negative
- Additional abstraction layer (acceptable trade-off)
- Need to maintain interface contracts

### Notes
- Data sources depend on backend service interfaces
- Backend services are injected via GetIt/Injectable
- To switch backends: implement interface and update DI configuration

