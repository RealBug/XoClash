import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class DeleteUserUseCase {

  DeleteUserUseCase(this.repository);
  final UserRepository repository;

  Future<void> execute() async {
    await repository.deleteUser();
  }
}



















