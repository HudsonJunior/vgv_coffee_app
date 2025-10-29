import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';
import 'package:vgv_coffee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:vgv_coffee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

class MockCoffeeRemoteDataSource extends Mock
    implements CoffeeRemoteDataSource {}

void main() {
  late MockCoffeeRemoteDataSource mockRemoteDataSource;
  late CoffeeRepository repository;

  setUp(() {
    mockRemoteDataSource = MockCoffeeRemoteDataSource();
    repository = CoffeeRepository(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('CoffeeRepository', () {
    const coffee = Coffee(
      imageUrl: 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg',
    );

    group('fetchCoffee', () {
      test('returns Right(Coffee) on success', () async {
        when(() => mockRemoteDataSource.fetchCoffee())
            .thenAnswer((_) async => const Right(coffee));

        final result = await repository.fetchCoffee();

        expect(result, const Right(coffee));
        verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
      });

      test('returns Left(Failure) on remote fetch failure', () async {
        const failure = NetworkFailure(message: 'Network error');
        when(() => mockRemoteDataSource.fetchCoffee())
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.fetchCoffee();

        expect(result, const Left(failure));
        verify(() => mockRemoteDataSource.fetchCoffee()).called(1);
      });
    });
  });
}
