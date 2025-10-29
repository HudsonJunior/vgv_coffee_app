import 'package:dartz/dartz.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';
import 'package:vgv_coffee_app/features/favorites/data/favorites_local_data_source.dart';

/// Repository for managing favorite coffees.
class FavoritesRepository {
  FavoritesRepository({
    required FavoritesLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final FavoritesLocalDataSource _localDataSource;

  /// Gets all favorite coffees.
  Future<Either<Failure, List<FavoriteCoffee>>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  /// Adds a coffee to favorites.
  Future<Either<Failure, Unit>> addFavorite(String imageUrl) {
    return _localDataSource.addFavorite(imageUrl);
  }

  /// Removes a coffee from favorites.
  Future<Either<Failure, Unit>> removeFavorite(String imageUrl) {
    return _localDataSource.removeFavorite(imageUrl);
  }

  /// Checks if a coffee is favorited.
  Future<Either<Failure, bool>> isFavorite(String imageUrl) {
    return _localDataSource.isFavorite(imageUrl);
  }
}
