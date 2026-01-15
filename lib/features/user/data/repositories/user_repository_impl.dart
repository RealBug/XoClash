import 'package:tictac/features/user/data/datasources/user_datasource.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

  UserRepositoryImpl({
    required this.dataSource,
  });
  final UserDataSource dataSource;

  @override
  Future<User?> getUser() async {
    return await dataSource.getUser();
  }

  @override
  Future<void> saveUser(User user) async {
    await dataSource.saveUser(user);
  }

  @override
  Future<bool> hasUser() async {
    return await dataSource.hasUser();
  }

  @override
  Future<void> deleteUser() async {
    await dataSource.deleteUser();
  }
}
