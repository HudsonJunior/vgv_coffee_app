import 'package:flutter_test/flutter_test.dart';
import 'package:vgv_coffee_app/features/coffee/data/models/coffee.dart';

void main() {
  group('Coffee', () {
    const imageUrl = 'https://coffee.alexflipnote.dev/o5Pn--mZWjM_coffee.jpg';

    test('creates instance with imageUrl', () {
      const coffee = Coffee(imageUrl: imageUrl);
      expect(coffee.imageUrl, imageUrl);
    });

    test('fromJson creates Coffee from JSON map', () {
      final json = {'file': imageUrl};
      final coffee = Coffee.fromJson(json);

      expect(coffee.imageUrl, imageUrl);
    });

    test('toJson converts Coffee to JSON map', () {
      const coffee = Coffee(imageUrl: imageUrl);
      final json = coffee.toJson();

      expect(json, {'file': imageUrl});
    });

    test('supports value equality', () {
      const coffee1 = Coffee(imageUrl: imageUrl);
      const coffee2 = Coffee(imageUrl: imageUrl);
      const coffee3 = Coffee(imageUrl: 'https://different.url');

      expect(coffee1, equals(coffee2));
      expect(coffee1, isNot(equals(coffee3)));
    });

    test('props include imageUrl', () {
      const coffee = Coffee(imageUrl: imageUrl);
      expect(coffee.props, [imageUrl]);
    });
  });
}
