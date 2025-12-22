import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class GetUserUseCase {

  GetUserUseCase(this.repository);
  final UserRepository repository;

  Future<User?> execute() async {
    return await repository.getUser();
  }
}


















