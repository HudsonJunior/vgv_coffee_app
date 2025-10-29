import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv_coffee_app/core/widgets/error_view.dart';
import 'package:vgv_coffee_app/core/widgets/loading_view.dart';
import 'package:vgv_coffee_app/features/coffee/screen/cubit/coffee_cubit.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_cubit.dart';
import 'package:vgv_coffee_app/features/favorites/screen/cubit/favorites_state.dart';
import 'package:vgv_coffee_app/features/favorites/screen/widgets/empty_favorites_view.dart';
import 'package:vgv_coffee_app/features/favorites/screen/widgets/favorite_coffee_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        if (state is FavoriteRemovedSuccess) {
          context.read<CoffeeCubit>().checkFavorite();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Coffee removed from favorites'),
              duration: Duration(seconds: 2),
            ),
          );
        } else if (state is FavoriteRemovedFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove coffee from favorites'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          FavoritesInitial() || FavoritesLoading() => const LoadingView(),
          FavoritesLoaded(:final favorites) => favorites.isEmpty
              ? const EmptyFavoritesView()
              : _FavoritesGrid(favorites: favorites),
          FavoritesFailed(:final failure) => ErrorView(
              message: failure.message,
              onRetry: context.read<FavoritesCubit>().loadFavorites,
            ),
        };
      },
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<FavoriteCoffee> favorites;

  const _FavoritesGrid({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final favorite = favorites[index];
                return FavoriteCoffeeCard(
                  favoriteCoffee: favorite,
                  onDelete: () {
                    context
                        .read<FavoritesCubit>()
                        .removeFavorite(favorite.imageUrl);
                  },
                );
              },
              childCount: favorites.length,
            ),
          ),
        ),
      ],
    );
  }
}
