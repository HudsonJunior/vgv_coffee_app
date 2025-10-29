import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/clients/shared_preferences_client.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';
import 'package:vgv_coffee_app/features/favorites/data/favorites_local_data_source.dart';

class MockSharedPreferencesClient extends Mock
    implements SharedPreferencesClient {}

void main() {
  late MockSharedPreferencesClient mockSharedPreferencesClient;
  late FavoritesLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferencesClient = MockSharedPreferencesClient();
    dataSource = FavoritesLocalDataSource(
      sharedPreferencesClient: mockSharedPreferencesClient,
    );
  });

  group('FavoritesLocalDataSource', () {
    const imageUrl1 = 'https://coffee.alexflipnote.dev/coffee1.jpg';
    const imageUrl2 = 'https://coffee.alexflipnote.dev/coffee2.jpg';
    final savedAt1 = DateTime(2024, 1, 1, 12, 0);
    final savedAt2 = DateTime(2024, 1, 2, 12, 0);

    group('getFavorites', () {
      test('returns empty list when no favorites stored', () async {
        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer((_) async => []);

        final result = await dataSource.getFavorites();

        result.fold(
          (failure) => fail('Should return Right'),
          (favorites) => expect(favorites, isEmpty),
        );
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });

      test('returns list of favorites when stored', () async {
        final favorite1 = FavoriteCoffee(
          imageUrl: imageUrl1,
          savedAt: savedAt1,
        );
        final favorite2 = FavoriteCoffee(
          imageUrl: imageUrl2,
          savedAt: savedAt2,
        );

        final jsonList = [
          jsonEncode(favorite1.toJson()),
          jsonEncode(favorite2.toJson()),
        ];

        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer((_) async => jsonList);

        final result = await dataSource.getFavorites();

        result.fold(
          (failure) => fail('Should return Right'),
          (favorites) {
            expect(favorites.length, 2);
            expect(favorites[0].imageUrl, imageUrl2);
            expect(favorites[1].imageUrl, imageUrl1);
          },
        );
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });

      test('returns Left(CacheFailure) on exception', () async {
        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenThrow(Exception('Storage error'));

        final result = await dataSource.getFavorites();

        expect(result, isA<Left<Failure, List<FavoriteCoffee>>>());
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, contains('Failed to load favorites'));
          },
          (favorites) => fail('Should return Left'),
        );
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });
    });

    group('addFavorite', () {
      test('adds favorite successfully', () async {
        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer((_) async => []);
        when(() =>
                mockSharedPreferencesClient.setStringList('favorites', any()))
            .thenAnswer((_) async => true);

        final result = await dataSource.addFavorite(imageUrl1);

        expect(result, const Right(unit));
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verify(() =>
                mockSharedPreferencesClient.setStringList('favorites', any()))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });

      test('does not add duplicate favorite', () async {
        final existingFavorite = FavoriteCoffee(
          imageUrl: imageUrl1,
          savedAt: savedAt1,
        );

        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer(
          (_) async => [jsonEncode(existingFavorite.toJson())],
        );

        final result = await dataSource.addFavorite(imageUrl1);

        expect(result, const Right(unit));
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNever(
          () => mockSharedPreferencesClient.setStringList('favorites', any()),
        );
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });
    });

    group('removeFavorite', () {
      test('removes favorite successfully', () async {
        final favorite1 = FavoriteCoffee(
          imageUrl: imageUrl1,
          savedAt: savedAt1,
        );
        final favorite2 = FavoriteCoffee(
          imageUrl: imageUrl2,
          savedAt: savedAt2,
        );

        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer(
          (_) async => [
            jsonEncode(favorite1.toJson()),
            jsonEncode(favorite2.toJson()),
          ],
        );
        when(() =>
                mockSharedPreferencesClient.setStringList('favorites', any()))
            .thenAnswer((_) async => true);

        final result = await dataSource.removeFavorite(imageUrl1);

        expect(result, const Right(unit));
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verify(() =>
                mockSharedPreferencesClient.setStringList('favorites', any()))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });
    });

    group('isFavorite', () {
      test('returns true when coffee is favorited', () async {
        final favorite = FavoriteCoffee(
          imageUrl: imageUrl1,
          savedAt: savedAt1,
        );

        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer(
          (_) async => [jsonEncode(favorite.toJson())],
        );

        final result = await dataSource.isFavorite(imageUrl1);

        result.fold(
          (failure) => fail('Should return Right'),
          (isFavorite) => expect(isFavorite, isTrue),
        );
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });

      test('returns false when coffee is not favorited', () async {
        when(() => mockSharedPreferencesClient.getStringList('favorites'))
            .thenAnswer((_) async => []);

        final result = await dataSource.isFavorite(imageUrl1);

        result.fold(
          (failure) => fail('Should return Right'),
          (isFavorite) => expect(isFavorite, isFalse),
        );
        verify(() => mockSharedPreferencesClient.getStringList('favorites'))
            .called(1);
        verifyNoMoreInteractions(mockSharedPreferencesClient);
      });
    });
  });
}
