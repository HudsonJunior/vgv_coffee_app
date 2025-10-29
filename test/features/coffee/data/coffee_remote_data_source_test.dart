import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/clients/api_client.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';
import 'package:vgv_coffee_app/features/coffee/data/sources/coffee_remote_data_source.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late CoffeeRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = CoffeeRemoteDataSource(apiClient: mockApiClient);
  });

  group('CoffeeRemoteDataSource', () {
    const imageUrl = 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg';
    final responseData = {'file': imageUrl};

    test('fetchCoffee returns Right(Coffee) on success', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => responseData,
      );

      final result = await dataSource.fetchCoffee();

      expect(result, isA<Right<Failure, Coffee>>());
      result.fold(
        (failure) => fail('Should return Right'),
        (coffee) => expect(coffee.imageUrl, imageUrl),
      );
      verify(() => mockApiClient.get(
            'https://coffee.alexflipnote.dev/random.json',
          )).called(1);
    });

    test('fetchCoffee returns Left(NetworkFailure) on DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: ''),
        message: 'Network error',
      );
      when(() => mockApiClient.get(any())).thenThrow(dioException);

      final result = await dataSource.fetchCoffee();

      expect(result, isA<Left<Failure, Coffee>>());
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'Network error');
        },
        (coffee) => fail('Should return Left'),
      );
    });

    test('fetchCoffee returns Left(UnknownFailure) on generic exception',
        () async {
      when(() => mockApiClient.get(any())).thenThrow(
        Exception('Unexpected error'),
      );

      final result = await dataSource.fetchCoffee();

      expect(result, isA<Left<Failure, Coffee>>());
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('unexpected error'));
        },
        (coffee) => fail('Should return Left'),
      );
    });
  });
}
