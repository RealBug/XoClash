# Presentation Errors

This directory contains presentation-layer error handling utilities.

## Structure

- **`error_extensions.dart`**: Riverpod-specific extensions for error handling
  - `AsyncValueErrorExtension`: Extensions on `AsyncValue` to access `AppException`

## Clean Architecture Compliance

✅ **Presentation Layer**: Depends on domain, uses infrastructure
- Extensions depend on Riverpod (presentation framework)
- Uses `AppException` from domain layer
- Provides convenient access to errors in UI components

## Usage

```dart
// In presentation layer (widgets, screens)
final asyncValue = ref.watch(userProvider);
if (asyncValue.hasError) {
  final appException = asyncValue.appException;
  if (appException?.isRetryable ?? false) {
    // Show retry button
  }
}
```







