import 'package:equatable/equatable.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';

/// Base class for favorites screen states.
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state before favorites are loaded.
final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// State when loading favorites.
final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// State when an error occurred while loading favorites.
final class FavoritesFailed extends FavoritesState {
  const FavoritesFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// State when favorites have been successfully loaded.
final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(this.favorites);

  final List<FavoriteCoffee> favorites;

  @override
  List<Object?> get props => [favorites];
}

/// State when a favorite has been successfully removed.
final class FavoriteRemovedSuccess extends FavoritesLoaded {
  final String imageUrl;

  const FavoriteRemovedSuccess(super.favorites, this.imageUrl);
}

/// State when a favorite has been successfully removed.
final class FavoriteRemovedFailed extends FavoritesLoaded {
  const FavoriteRemovedFailed(super.favorites);
}
