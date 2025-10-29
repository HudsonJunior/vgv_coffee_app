import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_coffee_app/core/di/injection.dart';
import 'package:vgv_coffee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_state.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';

/// Cubit for managing the coffee screen state.
class CoffeeCubit extends Cubit<CoffeeState> {
  CoffeeCubit() : super(const CoffeeInitial());

  final _repository = getIt<CoffeeRepository>();
  final _favoritesRepository = getIt<FavoritesRepository>();

  /// Fetches a new coffee image.
  void fetchCoffee() async {
    emit(const CoffeeLoading());

    final result = await _repository.fetchCoffee();

    result.fold(
      (failure) => emit(CoffeeFailed(failure)),
      (coffee) async {
        final isFavorite = await _favoritesRepository.isFavorite(
          coffee.imageUrl,
        );

        emit(
          CoffeeLoaded(
            coffee,
            isFavorite: isFavorite.getOrElse(() => false),
          ),
        );
      },
    );
  }

  /// Adds a coffee to favorites.
  void addFavorite() async {
    final currentState = state;
    if (currentState is! CoffeeLoaded) return;

    final result = await _favoritesRepository.addFavorite(
      currentState.coffee.imageUrl,
    );

    result.fold(
      (failure) => emit(
        CoffeeSaveToFavoritesFailed(
          currentState.coffee,
          isFavorite: false,
        ),
      ),
      (_) => emit(
        CoffeeSaveToFavoritesSuccess(
          currentState.coffee,
          isFavorite: true,
        ),
      ),
    );
  }

  void removeFavorite() async {
    final currentState = state;
    if (currentState is! CoffeeLoaded) return;

    final result = await _favoritesRepository.removeFavorite(
      currentState.coffee.imageUrl,
    );

    result.fold(
      (failure) => emit(
        CoffeeRemoveFromFavoritesFailed(
          currentState.coffee,
          isFavorite: true,
        ),
      ),
      (_) => emit(
        CoffeeRemoveFromFavoritesSuccess(
          currentState.coffee,
          isFavorite: false,
        ),
      ),
    );
  }

  void checkFavorite() async {
    final currentState = state;
    if (currentState is! CoffeeLoaded) return;

    final isFavorite = await _favoritesRepository.isFavorite(
      currentState.coffee.imageUrl,
    );

    emit(
      CoffeeLoaded(
        currentState.coffee,
        isFavorite: isFavorite.getOrElse(() => false),
      ),
    );
  }
}
