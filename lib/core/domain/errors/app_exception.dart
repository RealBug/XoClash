import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@Freezed(unionKey: 'type')
abstract class AppException with _$AppException implements Exception {
  const factory AppException.network({
    required String translationKey,
    String? code,
    StackTrace? stackTrace,
  }) = NetworkException;

  const factory AppException.storage({
    required String translationKey,
    String? code,
    StackTrace? stackTrace,
  }) = StorageException;

  const factory AppException.authentication({
    required String translationKey,
    String? code,
    StackTrace? stackTrace,
  }) = AuthenticationException;

  const factory AppException.validation({
    required String translationKey,
    String? code,
    StackTrace? stackTrace,
  }) = ValidationException;

  const factory AppException.unknown({
    required String translationKey,
    String? code,
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnknownException;
}

extension AppExceptionExtension on AppException {
  String get getTranslationKey {
    return when(
      network: (String translationKey, String? code, StackTrace? stackTrace) => translationKey,
      storage: (String translationKey, String? code, StackTrace? stackTrace) => translationKey,
      authentication: (String translationKey, String? code, StackTrace? stackTrace) => translationKey,
      validation: (String translationKey, String? code, StackTrace? stackTrace) => translationKey,
      unknown: (String translationKey, String? code, Object? originalError, StackTrace? stackTrace) => translationKey,
    );
  }

  String? get errorCode {
    return when(
      network: (String translationKey, String? code, StackTrace? stackTrace) => code,
      storage: (String translationKey, String? code, StackTrace? stackTrace) => code,
      authentication: (String translationKey, String? code, StackTrace? stackTrace) => code,
      validation: (String translationKey, String? code, StackTrace? stackTrace) => code,
      unknown: (String translationKey, String? code, Object? originalError, StackTrace? stackTrace) => code,
    );
  }

  bool get isRetryable {
    return when(
      network: (String translationKey, String? code, StackTrace? stackTrace) => true,
      storage: (String translationKey, String? code, StackTrace? stackTrace) => false,
      authentication: (String translationKey, String? code, StackTrace? stackTrace) => true,
      validation: (String translationKey, String? code, StackTrace? stackTrace) => false,
      unknown: (String translationKey, String? code, Object? originalError, StackTrace? stackTrace) => false,
    );
  }
}
