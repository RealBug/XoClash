import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac/features/auth/domain/usecases/validate_email_usecase.dart';
import 'package:tictac/features/auth/domain/usecases/validate_password_usecase.dart';
import 'package:tictac/features/auth/domain/usecases/validate_username_usecase.dart';

final Provider<ValidateUsernameUseCase> validateUsernameUseCaseProvider = Provider<ValidateUsernameUseCase>(
  (Ref ref) => ValidateUsernameUseCase(),
);

final Provider<ValidateEmailUseCase> validateEmailUseCaseProvider = Provider<ValidateEmailUseCase>(
  (Ref ref) => ValidateEmailUseCase(),
);

final Provider<ValidatePasswordUseCase> validatePasswordUseCaseProvider = Provider<ValidatePasswordUseCase>(
  (Ref ref) => ValidatePasswordUseCase(),
);

