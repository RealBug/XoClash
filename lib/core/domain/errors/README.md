# Domain Errors

This directory contains domain-level error definitions following Clean Architecture principles.

## Structure

- **`app_exception.dart`**: Core exception types used across the application
  - `NetworkException`: Network-related errors
  - `StorageException`: Storage/database errors
  - `AuthenticationException`: Authentication errors
  - `ValidationException`: Validation errors
  - `UnknownException`: Unknown/unexpected errors

## Clean Architecture Compliance

✅ **Domain Layer**: Pure business logic, no dependencies on infrastructure
- `AppException` is a domain entity (no dependencies on Flutter, Riverpod, or services)
- Can be used by use cases, repositories, and other domain components
- Extensions provide domain-level logic (`userMessage`, `errorCode`, `isRetryable`)

## Usage

```dart
// In domain layer (use cases, repositories)
throw AppException.network(
  message: 'Connection failed',
  code: 'NETWORK_ERROR',
);

// In infrastructure layer (error handler)
final appException = errorHandler.handleError(error, stackTrace);
```







