import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_coffee_app/core/widgets/error_view.dart';
import 'package:vgv_coffee_app/core/widgets/loading_view.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_cubit.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_state.dart';
import 'package:vgv_coffee_app/features/coffee/screen/widgets/coffee_action_buttons.dart';
import 'package:vgv_coffee_app/features/coffee/screen/widgets/coffee_image_card.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_cubit.dart';

class CoffeeScreen extends StatelessWidget {
  const CoffeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoffeeCubit, CoffeeState>(
      listener: (context, state) {
        if (state is CoffeeSaveToFavoritesSuccess ||
            state is CoffeeRemoveFromFavoritesSuccess) {
          context.read<FavoritesCubit>().loadFavorites();
        } else if (state is CoffeeSaveToFavoritesFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save coffee to favorites!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: switch (state) {
                    CoffeeInitial() => _InitialView(),
                    CoffeeLoading() => const LoadingView(),
                    CoffeeLoaded(:final coffee) => CoffeeImageCard(
                        imageUrl: coffee.imageUrl,
                      ),
                    CoffeeFailed(:final failure) => ErrorView(
                        message: failure.message,
                        onRetry: context.read<CoffeeCubit>().fetchCoffee,
                      ),
                  }),
            ),
            CoffeeActionButtons(
              isLoading: state is CoffeeLoading,
              isLoaded: state is CoffeeLoaded,
              isFavorite: state is CoffeeLoaded ? state.isFavorite : false,
              onNewCoffee: context.read<CoffeeCubit>().fetchCoffee,
              onSaveFavorite: context.read<CoffeeCubit>().addFavorite,
              onRemoveFavorite: context.read<CoffeeCubit>().removeFavorite,
            )
          ],
        );
      },
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready for some coffee?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "New Coffee" to get started',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
