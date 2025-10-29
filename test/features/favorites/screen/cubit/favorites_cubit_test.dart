import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/di/injection.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_cubit.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_state.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockFavoritesRepository mockRepository;
  late FavoritesCubit cubit;

  setUp(() {
    mockRepository = MockFavoritesRepository();
    getIt.registerLazySingleton<FavoritesRepository>(() => mockRepository);
    cubit = FavoritesCubit();
  });

  tearDown(() {
    getIt.reset();
  });

  group('FavoritesCubit', () {
    const imageUrl = 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg';
    final favoriteCoffee = FavoriteCoffee(
      imageUrl: imageUrl,
      savedAt: DateTime(2024, 1, 1),
    );

    test('initial state is FavoritesInitial', () {
      expect(cubit.state, const FavoritesInitial());
    });

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoritesLoading, FavoritesLoaded] when loadFavorites succeeds',
      build: () => cubit,
      act: (cubit) {
        when(() => mockRepository.getFavorites())
            .thenAnswer((_) async => Right([favoriteCoffee]));
        return cubit.loadFavorites();
      },
      expect: () => [
        const FavoritesLoading(),
        FavoritesLoaded([favoriteCoffee]),
      ],
      verify: (_) {
        verify(() => mockRepository.getFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoritesLoading, FavoritesFailed] when loadFavorites fails',
      build: () => cubit,
      act: (cubit) {
        const failure = CacheFailure(message: 'Cache error');
        when(() => mockRepository.getFavorites())
            .thenAnswer((_) async => const Left(failure));
        return cubit.loadFavorites();
      },
      expect: () => [
        const FavoritesLoading(),
        const FavoritesFailed(CacheFailure(message: 'Cache error')),
      ],
      verify: (_) {
        verify(() => mockRepository.getFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoriteRemovedSuccess, FavoritesLoading, FavoritesLoaded] when removeFavorite succeeds',
      build: () => cubit,
      seed: () => FavoritesLoaded([favoriteCoffee]),
      act: (cubit) {
        when(() => mockRepository.removeFavorite(imageUrl))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockRepository.getFavorites())
            .thenAnswer((_) async => const Right([]));
        return cubit.removeFavorite(imageUrl);
      },
      expect: () => [
        FavoriteRemovedSuccess([favoriteCoffee], imageUrl),
        const FavoritesLoading(),
        const FavoritesLoaded([]),
      ],
      verify: (_) {
        verify(() => mockRepository.removeFavorite(imageUrl)).called(1);
        verify(() => mockRepository.getFavorites()).called(1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'emits [FavoriteRemovedFailed] when removeFavorite fails',
      build: () => cubit,
      seed: () => FavoritesLoaded([favoriteCoffee]),
      act: (cubit) {
        const failure = CacheFailure(message: 'Failed to remove');
        when(() => mockRepository.removeFavorite(imageUrl))
            .thenAnswer((_) async => const Left(failure));
        return cubit.removeFavorite(imageUrl);
      },
      expect: () => [
        FavoriteRemovedFailed([favoriteCoffee]),
      ],
      verify: (_) {
        verify(() => mockRepository.removeFavorite(imageUrl)).called(1);
        verifyNever(() => mockRepository.getFavorites());
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'does not emit any state when removeFavorite is called with non-FavoritesLoaded state',
      build: () => cubit,
      seed: () => const FavoritesInitial(),
      act: (cubit) => cubit.removeFavorite(imageUrl),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRepository.removeFavorite(any()));
      },
    );
  });
}
