import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/delete_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late DeleteUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = DeleteUserUseCase(mockRepository);
  });

  test('should delete user', () async {
    when(() => mockRepository.deleteUser())
        .thenAnswer((_) async => Future<void>.value());

    await useCase.execute();

    verify(() => mockRepository.deleteUser()).called(1);
  });

  test('should propagate errors from repository', () async {
    when(() => mockRepository.deleteUser())
        .thenThrow(Exception('Error deleting user'));

    expect(() => useCase.execute(), throwsException);
    verify(() => mockRepository.deleteUser()).called(1);
  });
}




















