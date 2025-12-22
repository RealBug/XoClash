import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/entities/user.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/get_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  test('should return user when user exists', () async {
    const User expectedUser = User(username: 'testuser');

    when(() => mockRepository.getUser())
        .thenAnswer((_) async => expectedUser);

    final User? result = await useCase.execute();

    expect(result, equals(expectedUser));
    verify(() => mockRepository.getUser()).called(1);
  });

  test('should return null when user does not exist', () async {
    when(() => mockRepository.getUser())
        .thenAnswer((_) async => null);

    final User? result = await useCase.execute();

    expect(result, isNull);
    verify(() => mockRepository.getUser()).called(1);
  });

  test('should propagate errors from repository', () async {
    when(() => mockRepository.getUser())
        .thenThrow(Exception('Error getting user'));

    expect(() => useCase.execute(), throwsException);
    verify(() => mockRepository.getUser()).called(1);
  });
}




















