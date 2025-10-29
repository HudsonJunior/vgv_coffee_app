import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:vgv_coffee_app/core/clients/shared_preferences_client.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';

/// Data source for managing favorite coffees locally using SharedPreferencesClient.
class FavoritesLocalDataSource {
  FavoritesLocalDataSource({
    required SharedPreferencesClient sharedPreferencesClient,
  }) : _sharedPreferencesClient = sharedPreferencesClient;

  final SharedPreferencesClient _sharedPreferencesClient;

  static const _favoritesKey = 'favorites';

  /// Gets all favorite coffees.
  Future<Either<Failure, List<FavoriteCoffee>>> getFavorites() async {
    try {
      final favoritesJson = await _sharedPreferencesClient.getStringList(
        _favoritesKey,
      );

      final favorites = favoritesJson
          .map((json) => FavoriteCoffee.fromJson(
                jsonDecode(json) as Map<String, dynamic>,
              ))
          .toList();

      favorites.sort((a, b) => b.savedAt.compareTo(a.savedAt));

      return Right(favorites);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to load favorites: $e'),
      );
    }
  }

  /// Adds a coffee to favorites.
  Future<Either<Failure, Unit>> addFavorite(String imageUrl) async {
    try {
      final favoritesResult = await getFavorites();

      return favoritesResult.fold(
        left,
        (favorites) async {
          if (favorites.any((f) => f.imageUrl == imageUrl)) {
            return const Right(unit);
          }

          final newFavorite = FavoriteCoffee(
            imageUrl: imageUrl,
            savedAt: DateTime.now(),
          );

          final updatedFavorites = [newFavorite, ...favorites];

          final favoritesJson =
              updatedFavorites.map((f) => jsonEncode(f.toJson())).toList();

          await _sharedPreferencesClient.setStringList(
            _favoritesKey,
            favoritesJson,
          );

          return const Right(unit);
        },
      );
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to add favorite: $e'),
      );
    }
  }

  /// Removes a coffee from favorites.
  Future<Either<Failure, Unit>> removeFavorite(String imageUrl) async {
    try {
      final favoritesResult = await getFavorites();

      return favoritesResult.fold(
        left,
        (favorites) async {
          final updatedFavorites =
              favorites.where((f) => f.imageUrl != imageUrl).toList();

          final favoritesJson =
              updatedFavorites.map((f) => jsonEncode(f.toJson())).toList();

          await _sharedPreferencesClient.setStringList(
            _favoritesKey,
            favoritesJson,
          );

          return const Right(unit);
        },
      );
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to remove favorite: $e'),
      );
    }
  }

  /// Checks if a coffee is favorited.
  Future<Either<Failure, bool>> isFavorite(String imageUrl) async {
    final favoritesResult = await getFavorites();

    return favoritesResult.fold(
      left,
      (favorites) => Right(favorites.any((f) => f.imageUrl == imageUrl)),
    );
  }
}
