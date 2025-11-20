import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns expected human-friendly names', () {
      expect(
        Sandwich(
                type: SandwichType.veggieDelight,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Veggie Delight',
      );
      expect(
        Sandwich(
                type: SandwichType.chickenTeriyaki,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Chicken Teriyaki',
      );
      expect(
        Sandwich(
                type: SandwichType.tunaMelt,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Tuna Melt',
      );
      expect(
        Sandwich(
                type: SandwichType.meatballMarinara,
                isFootlong: true,
                breadType: BreadType.white)
            .name,
        'Meatball Marinara',
      );
    });

    test('image getter builds correct asset path for footlong and six_inch',
        () {
      final footlong = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      expect(
        footlong.image,
        'assets/images/${SandwichType.meatballMarinara.name}_footlong.png',
      );

      final sixInch = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(
        sixInch.image,
        'assets/images/${SandwichType.meatballMarinara.name}_six_inch.png',
      );
    });

    test('fromJson maps known values correctly', () {
      final json = {
        'type': 'tunaMelt',
        'isFootlong': false,
        'breadType': 'wholemeal',
      };
      final s = Sandwich.fromJson(json);
      expect(s.type, SandwichType.tunaMelt);
      expect(s.isFootlong, isFalse);
      expect(s.breadType, BreadType.wholemeal);
    });

    test('fromJson falls back to defaults for unknown or missing values', () {
      final s1 = Sandwich.fromJson({'type': 'unknownType'});
      expect(s1.type, SandwichType.veggieDelight);
      expect(s1.isFootlong, isTrue); // default in factory
      expect(s1.breadType, BreadType.white);

      final s2 = Sandwich.fromJson({'breadType': 'unknownBread'});
      expect(s2.type, SandwichType.veggieDelight);
      expect(s2.breadType, BreadType.white);
    });

    test('fromJson handles explicit null values by using defaults', () {
      final s = Sandwich.fromJson(
          {'type': null, 'isFootlong': null, 'breadType': null});
      expect(s.type, SandwichType.veggieDelight);
      expect(s.isFootlong, isTrue);
      expect(s.breadType, BreadType.white);
    });

    test('image uses enum name exactly for all types and sizes', () {
      for (final type in SandwichType.values) {
        final sFoot =
            Sandwich(type: type, isFootlong: true, breadType: BreadType.white);
        final sSix =
            Sandwich(type: type, isFootlong: false, breadType: BreadType.white);

        expect(sFoot.image, 'assets/images/${type.name}_footlong.png');
        expect(sSix.image, 'assets/images/${type.name}_six_inch.png');
      }
    });
  });
}
