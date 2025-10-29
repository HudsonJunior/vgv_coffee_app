import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vgv_coffee_app/core/di/injection.dart';
import 'package:vgv_coffee_app/core/errors/failures.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';
import 'package:vgv_coffee_app/features/coffee/data/repository/coffee_repository.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_cubit.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_state.dart';
import 'package:vgv_coffee_app/features/favorites/core/repository/favorites_repository.dart';

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late MockCoffeeRepository mockRepository;
  late MockFavoritesRepository mockFavoritesRepository;
  late CoffeeCubit cubit;

  setUp(() {
    mockRepository = MockCoffeeRepository();
    mockFavoritesRepository = MockFavoritesRepository();
    getIt.registerLazySingleton<CoffeeRepository>(() => mockRepository);
    getIt.registerLazySingleton<FavoritesRepository>(
      () => mockFavoritesRepository,
    );
  });

  tearDown(() {
    getIt.reset();
  });

  group('CoffeeCubit', () {
    const coffee = Coffee(
      imageUrl: 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg',
    );

    test('initial state is CoffeeInitial', () {
      cubit = CoffeeCubit();

      expect(cubit.state, const CoffeeInitial());
    });

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoading, CoffeeLoaded] when fetchCoffee succeeds',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      act: (cubit) {
        when(() => mockRepository.fetchCoffee())
            .thenAnswer((_) async => const Right(coffee));
        when(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Right(false));
        return cubit.fetchCoffee();
      },
      expect: () => [
        const CoffeeLoading(),
        const CoffeeLoaded(coffee, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockRepository.fetchCoffee()).called(1);
        verify(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoading, CoffeeFailed] when fetchCoffee fails',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      act: (cubit) {
        const failure = NetworkFailure(message: 'Network error');
        when(() => mockRepository.fetchCoffee())
            .thenAnswer((_) async => const Left(failure));
        return cubit.fetchCoffee();
      },
      expect: () => [
        const CoffeeLoading(),
        const CoffeeFailed(NetworkFailure(message: 'Network error')),
      ],
      verify: (_) {
        verify(() => mockRepository.fetchCoffee()).called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeSaveToFavoritesSuccess] when addFavorite succeeds',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: false),
      act: (cubit) {
        when(() => mockFavoritesRepository.addFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Right(unit));
        return cubit.addFavorite();
      },
      expect: () => [
        const CoffeeSaveToFavoritesSuccess(coffee, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.addFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeSaveToFavoritesFailed] when addFavorite fails',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: false),
      act: (cubit) {
        const failure = CacheFailure(message: 'Cache error');
        when(() => mockFavoritesRepository.addFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Left(failure));
        return cubit.addFavorite();
      },
      expect: () => [
        const CoffeeSaveToFavoritesFailed(coffee, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.addFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'does not emit any state when addFavorite is called with non-CoffeeLoaded state',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeInitial(),
      act: (cubit) => cubit.addFavorite(),
      expect: () => [],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeRemoveFromFavoritesSuccess] when removeFavorite succeeds',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: true),
      act: (cubit) {
        when(() => mockFavoritesRepository.removeFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Right(unit));
        return cubit.removeFavorite();
      },
      expect: () => [
        const CoffeeRemoveFromFavoritesSuccess(coffee, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.removeFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeRemoveFromFavoritesFailed] when removeFavorite fails',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: true),
      act: (cubit) {
        const failure = CacheFailure(message: 'Cache error');
        when(() => mockFavoritesRepository.removeFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Left(failure));
        return cubit.removeFavorite();
      },
      expect: () => [
        const CoffeeRemoveFromFavoritesFailed(coffee, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.removeFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'does not emit any state when removeFavorite is called with non-CoffeeLoaded state',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeInitial(),
      act: (cubit) => cubit.removeFavorite(),
      expect: () => [],
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoaded] with isFavorite true when checkFavorite returns true',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: false),
      act: (cubit) {
        when(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Right(true));
        return cubit.checkFavorite();
      },
      expect: () => [
        const CoffeeLoaded(coffee, isFavorite: true),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoaded] with isFavorite false when checkFavorite returns false',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: true),
      act: (cubit) {
        when(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Right(false));
        return cubit.checkFavorite();
      },
      expect: () => [
        const CoffeeLoaded(coffee, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'emits [CoffeeLoaded] with isFavorite false when checkFavorite fails',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeLoaded(coffee, isFavorite: true),
      act: (cubit) {
        const failure = CacheFailure(message: 'Cache error');
        when(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .thenAnswer((_) async => const Left(failure));
        return cubit.checkFavorite();
      },
      expect: () => [
        const CoffeeLoaded(coffee, isFavorite: false),
      ],
      verify: (_) {
        verify(() => mockFavoritesRepository.isFavorite(coffee.imageUrl))
            .called(1);
      },
    );

    blocTest<CoffeeCubit, CoffeeState>(
      'does not emit any state when checkFavorite is called with non-CoffeeLoaded state',
      build: () {
        cubit = CoffeeCubit();
        return cubit;
      },
      seed: () => const CoffeeInitial(),
      act: (cubit) => cubit.checkFavorite(),
      expect: () => [],
    );
  });
}
