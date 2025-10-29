import 'package:flutter/material.dart';

/// Widget that displays action buttons for coffee operations.
class CoffeeActionButtons extends StatelessWidget {
  const CoffeeActionButtons({
    required this.onNewCoffee,
    required this.onSaveFavorite,
    required this.onRemoveFavorite,
    required this.isLoading,
    required this.isLoaded,
    required this.isFavorite,
    super.key,
  });

  final VoidCallback onNewCoffee;
  final VoidCallback onSaveFavorite;
  final VoidCallback onRemoveFavorite;
  final bool isLoading;
  final bool isLoaded;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: isLoading ? null : onNewCoffee,
              icon: const Icon(Icons.refresh),
              label: const Text('New Coffee'),
            ),
          ),
          if (isLoaded) ...[
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : isFavorite
                        ? onRemoveFavorite
                        : onSaveFavorite,
                icon: isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_outline),
                label: isFavorite
                    ? const Text('Unfavorite')
                    : const Text('Favorite'),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
