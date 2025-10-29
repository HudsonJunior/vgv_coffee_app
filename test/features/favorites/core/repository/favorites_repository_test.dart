import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';
import 'package:vgv_coffee_app/features/favorites/data/favorites_local_data_source.dart';

class MockFavoritesLocalDataSource extends Mock
    implements FavoritesLocalDataSource {}

void main() {
  late MockFavoritesLocalDataSource mockLocalDataSource;
  late FavoritesRepository repository;

  setUp(() {
    mockLocalDataSource = MockFavoritesLocalDataSource();
    repository = FavoritesRepository(localDataSource: mockLocalDataSource);
  });

  group('FavoritesRepository', () {
    const imageUrl = 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg';
    final favoriteCoffee = FavoriteCoffee(
      imageUrl: imageUrl,
      savedAt: DateTime(2024, 1, 1),
    );

    group('getFavorites', () {
      test('returns Right(List<FavoriteCoffee>) on success', () async {
        final favorites = [favoriteCoffee];
        when(() => mockLocalDataSource.getFavorites())
            .thenAnswer((_) async => Right(favorites));

        final result = await repository.getFavorites();

        expect(result, Right(favorites));
        verify(() => mockLocalDataSource.getFavorites()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('returns Left(Failure) on error', () async {
        const failure = CacheFailure(message: 'Cache error');
        when(() => mockLocalDataSource.getFavorites())
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.getFavorites();

        expect(result, const Left(failure));
        verify(() => mockLocalDataSource.getFavorites()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });

    group('addFavorite', () {
      test('returns Right(unit) on success', () async {
        when(() => mockLocalDataSource.addFavorite(any()))
            .thenAnswer((_) async => const Right(unit));

        final result = await repository.addFavorite(imageUrl);

        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.addFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('returns Left(Failure) on error', () async {
        const failure = CacheFailure(message: 'Failed to add');
        when(() => mockLocalDataSource.addFavorite(any()))
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.addFavorite(imageUrl);

        expect(result, const Left(failure));
        verify(() => mockLocalDataSource.addFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });

    group('removeFavorite', () {
      test('returns Right(unit) on success', () async {
        when(() => mockLocalDataSource.removeFavorite(any()))
            .thenAnswer((_) async => const Right(unit));

        final result = await repository.removeFavorite(imageUrl);

        expect(result, const Right(unit));
        verify(() => mockLocalDataSource.removeFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('returns Left(Failure) on error', () async {
        const failure = CacheFailure(message: 'Failed to remove');
        when(() => mockLocalDataSource.removeFavorite(any()))
            .thenAnswer((_) async => const Left(failure));

        final result = await repository.removeFavorite(imageUrl);

        expect(result, const Left(failure));
        verify(() => mockLocalDataSource.removeFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });

    group('isFavorite', () {
      test('returns Right(true) when favorited', () async {
        when(() => mockLocalDataSource.isFavorite(any()))
            .thenAnswer((_) async => const Right(true));

        final result = await repository.isFavorite(imageUrl);

        expect(result, const Right(true));
        verify(() => mockLocalDataSource.isFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });

      test('returns Right(false) when not favorited', () async {
        when(() => mockLocalDataSource.isFavorite(any()))
            .thenAnswer((_) async => const Right(false));

        final result = await repository.isFavorite(imageUrl);

        expect(result, const Right(false));
        verify(() => mockLocalDataSource.isFavorite(imageUrl)).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      });
    });
  });
}
