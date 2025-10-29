import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';

class FavoriteCoffeeCard extends StatelessWidget {
  const FavoriteCoffeeCard({
    required this.favoriteCoffee,
    required this.onDelete,
    super.key,
  });

  final FavoriteCoffee favoriteCoffee;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: favoriteCoffee.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Center(
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton.filled(
              onPressed: onDelete,
              icon: const Icon(Icons.favorite),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
