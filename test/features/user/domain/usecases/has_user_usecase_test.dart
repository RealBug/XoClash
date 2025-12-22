import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictac/features/user/domain/repositories/user_repository.dart';
import 'package:tictac/features/user/domain/usecases/has_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late HasUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = HasUserUseCase(mockRepository);
  });

  test('should return true when user exists', () async {
    when(() => mockRepository.hasUser())
        .thenAnswer((_) async => true);

    final bool result = await useCase.execute();

    expect(result, isTrue);
    verify(() => mockRepository.hasUser()).called(1);
  });

  test('should return false when user does not exist', () async {
    when(() => mockRepository.hasUser())
        .thenAnswer((_) async => false);

    final bool result = await useCase.execute();

    expect(result, isFalse);
    verify(() => mockRepository.hasUser()).called(1);
  });

  test('should propagate errors from repository', () async {
    when(() => mockRepository.hasUser())
        .thenThrow(Exception('Error checking user'));

    expect(() => useCase.execute(), throwsException);
    verify(() => mockRepository.hasUser()).called(1);
  });
}




















