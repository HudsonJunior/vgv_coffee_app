import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_coffee_app/core/di/injection.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_state.dart';

/// Cubit for managing the favorites screen state.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial());

  final _repository = getIt<FavoritesRepository>();

  /// Loads all favorite coffees.
  void loadFavorites() async {
    emit(const FavoritesLoading());

    final result = await _repository.getFavorites();

    result.fold(
      (failure) => emit(FavoritesFailed(failure)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  /// Removes a coffee from favorites and reloads the list.
  void removeFavorite(String imageUrl) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded) return;

    final result = await _repository.removeFavorite(imageUrl);

    result.fold(
      (failure) {
        emit(FavoriteRemovedFailed(currentState.favorites));
      },
      (_) {
        emit(FavoriteRemovedSuccess(currentState.favorites, imageUrl));
        loadFavorites();
      },
    );
  }
}
