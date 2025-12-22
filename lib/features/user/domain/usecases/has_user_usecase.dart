import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class HasUserUseCase {

  HasUserUseCase(this.repository);
  final UserRepository repository;

  Future<bool> execute() async {
    return await repository.hasUser();
  }
}



















