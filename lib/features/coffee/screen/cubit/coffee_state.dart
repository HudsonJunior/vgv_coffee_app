import 'package:equatable/equatable.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';

/// Base class for coffee screen states.
sealed class CoffeeState extends Equatable {
  const CoffeeState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any coffee is loaded.
final class CoffeeInitial extends CoffeeState {
  const CoffeeInitial();
}

/// State when fetching a coffee image.
final class CoffeeLoading extends CoffeeState {
  const CoffeeLoading();
}

/// State when an error occurred while fetching coffee.
final class CoffeeFailed extends CoffeeState {
  const CoffeeFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// State when a coffee image has been successfully loaded.
final class CoffeeLoaded extends CoffeeState {
  const CoffeeLoaded(this.coffee, {required this.isFavorite});

  final Coffee coffee;
  final bool isFavorite;

  @override
  List<Object?> get props => [coffee, isFavorite];
}

/// State when an error occurred while saving a coffee to favorites.
final class CoffeeSaveToFavoritesFailed extends CoffeeLoaded {
  const CoffeeSaveToFavoritesFailed(super.coffee, {required super.isFavorite});
}

/// State when a coffee has been successfully saved to favorites.
final class CoffeeSaveToFavoritesSuccess extends CoffeeLoaded {
  const CoffeeSaveToFavoritesSuccess(super.coffee, {required super.isFavorite});
}

/// State when an error occurred while removing a coffee from favorites.
final class CoffeeRemoveFromFavoritesFailed extends CoffeeLoaded {
  const CoffeeRemoveFromFavoritesFailed(
    super.coffee, {
    required super.isFavorite,
  });
}

/// State when a coffee has been successfully removed from favorites.
final class CoffeeRemoveFromFavoritesSuccess extends CoffeeLoaded {
  const CoffeeRemoveFromFavoritesSuccess(
    super.coffee, {
    required super.isFavorite,
  });
}
