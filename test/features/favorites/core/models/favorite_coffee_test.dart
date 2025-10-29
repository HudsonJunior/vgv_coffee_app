import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_coffee_app/features/favorites/core/models/favorite_coffee.dart';

void main() {
  group('FavoriteCoffee', () {
    const imageUrl = 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg';
    final savedAt = DateTime(2024, 1, 1, 12, 0);

    test('creates instance with imageUrl and savedAt', () {
      final favoriteCoffee = FavoriteCoffee(
        imageUrl: imageUrl,
        savedAt: savedAt,
      );

      expect(favoriteCoffee.imageUrl, imageUrl);
      expect(favoriteCoffee.savedAt, savedAt);
    });

    test('fromJson creates FavoriteCoffee from JSON map', () {
      final json = {
        'imageUrl': imageUrl,
        'savedAt': savedAt.toIso8601String(),
      };

      final favoriteCoffee = FavoriteCoffee.fromJson(json);

      expect(favoriteCoffee.imageUrl, imageUrl);
      expect(favoriteCoffee.savedAt, savedAt);
    });

    test('toJson converts FavoriteCoffee to JSON map', () {
      final favoriteCoffee = FavoriteCoffee(
        imageUrl: imageUrl,
        savedAt: savedAt,
      );

      final json = favoriteCoffee.toJson();

      expect(json, {
        'imageUrl': imageUrl,
        'savedAt': savedAt.toIso8601String(),
      });
    });

    test('supports value equality', () {
      final favoriteCoffee1 = FavoriteCoffee(
        imageUrl: imageUrl,
        savedAt: savedAt,
      );
      final favoriteCoffee2 = FavoriteCoffee(
        imageUrl: imageUrl,
        savedAt: savedAt,
      );
      final favoriteCoffee3 = FavoriteCoffee(
        imageUrl: 'https://different.url',
        savedAt: savedAt,
      );

      expect(favoriteCoffee1, equals(favoriteCoffee2));
      expect(favoriteCoffee1, isNot(equals(favoriteCoffee3)));
    });

    test('props include imageUrl and savedAt', () {
      final favoriteCoffee = FavoriteCoffee(
        imageUrl: imageUrl,
        savedAt: savedAt,
      );

      expect(favoriteCoffee.props, [imageUrl, savedAt]);
    });
  });
}
