import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vgv_coffee_app/core/di/injection.dart';
import 'package:vgv_coffee_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(
    () async {
      await getIt.reset();
      (await SharedPreferences.getInstance()).clear();
    },
  );

  group(
    'VGV Coffee App Integration Tests',
    () {
      testWidgets(
        'Complete flow: fetch coffee, favorite, unfavorite, check favorites tab',
        (tester) async {
          // Open the app
          await app.main();
          await tester.pumpAndSettle();

          // Verify we're on the Coffee screen
          expect(find.text('Ready for some coffee?'), findsOneWidget);

          // Fetch a new coffee
          final newCoffeeButton = find.text('New Coffee');
          expect(newCoffeeButton, findsOneWidget);
          await tester.tap(newCoffeeButton);
          await tester.pumpAndSettle();

          // Verify the coffee image is displayed
          // The image should be in a Card widget
          expect(find.byType(CachedNetworkImage), findsOneWidget);

          // The "Ready for some coffee?" text should be gone
          expect(find.text('Ready for some coffee?'), findsNothing);

          // Save as favorite
          final favoriteButton = find.text('Favorite');
          expect(favoriteButton, findsOneWidget);
          await tester.tap(favoriteButton);
          await tester.pumpAndSettle();

          // Verify the button changed to "Unfavorite"
          expect(find.text('Unfavorite'), findsOneWidget);
          expect(find.text('Favorite'), findsNothing);

          // Unfavorite the coffee from the Coffee screen
          final unfavoriteButton = find.text('Unfavorite');
          await tester.tap(unfavoriteButton);
          await tester.pumpAndSettle();

          // Verify the button changed back to "Favorite"
          expect(find.text('Favorite'), findsOneWidget);
          expect(find.text('Unfavorite'), findsNothing);

          // Favorite it again for the favorites tab test
          await tester.tap(find.text('Favorite'));
          await tester.pumpAndSettle();

          // Verify it's favorited
          expect(find.text('Unfavorite'), findsOneWidget);

          // Open the Favorites tab
          final favoritesIcon = find.byIcon(Icons.favorite_outline);
          expect(favoritesIcon, findsWidgets);
          await tester.tap(favoritesIcon.first);
          await tester.pumpAndSettle();

          // Verify we're on the Favorites screen by checking AppBar
          final appBar = find.byType(AppBar);
          final favoritesTitle = find.descendant(
            of: appBar,
            matching: find.text('Favorites'),
          );
          expect(favoritesTitle, findsOneWidget);

          // Verify the saved coffee is displayed
          expect(find.byType(CachedNetworkImage), findsOneWidget);

          // Unfavorite from the favorites tab
          // The favorite card has a filled heart icon button to remove it
          final favoriteIcon = find.byIcon(Icons.favorite);
          await tester.tap(favoriteIcon.first);

          // Wait for the UI to update
          await tester.pumpAndSettle();

          expect(find.byType(CachedNetworkImage), findsNothing);

          // Verify the empty state message appears
          expect(find.text('No favorites yet'), findsOneWidget);
        },
      );

      testWidgets('Can fetch multiple different coffees', (tester) async {
        // Start the app
        app.main();
        await tester.pumpAndSettle();

        // Fetch first coffee
        final newCoffeeButton = find.text('New Coffee');
        await tester.tap(newCoffeeButton);
        await tester.pumpAndSettle();

        // Verify coffee is displayed
        expect(find.byType(CachedNetworkImage), findsOneWidget);

        // Fetch second coffee
        await tester.tap(newCoffeeButton);
        await tester.pumpAndSettle();

        // Verify coffee is still displayed
        expect(find.byType(CachedNetworkImage), findsOneWidget);

        // Fetch third coffee
        await tester.tap(newCoffeeButton);
        await tester.pumpAndSettle();

        // Verify coffee is still displayed
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      });
    },
  );
}
