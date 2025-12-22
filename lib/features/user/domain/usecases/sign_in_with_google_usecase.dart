import 'package:tictac/features/auth/data/datasources/auth_datasource.dart';
import 'package:tictac/features/auth/data/services/auth_backend_service.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class SignInWithGoogleUseCase {

  SignInWithGoogleUseCase({
    required this.authDataSource,
    required this.userRepository,
  });
  final AuthDataSource authDataSource;
  final UserRepository userRepository;

  Future<User> execute() async {
    final AuthResult authResult = await authDataSource.signInWithGoogle();
    
    final String username = authResult.displayName ?? 
                     authResult.email?.split('@')[0] ?? 
                     'Google User';
    
    final User user = User(
      username: username,
      email: authResult.email,
      avatar: authResult.photoUrl,
    );
    
    await userRepository.saveUser(user);
    return user;
  }
}
