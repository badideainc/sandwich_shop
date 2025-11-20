import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    test('initial cart is empty', () {
      final cart = Cart();
      expect(cart.count, 0);
      expect(cart.sandwiches, isEmpty);
    });

    test(
        'add one sandwich increases count and stores a copy (not same instance)',
        () {
      final cart = Cart();
      final original = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );

      cart.add(original);
      expect(cart.count, 1);

      final stored = cart.sandwiches.first;
      // stored should not be the exact same instance as original
      expect(identical(stored, original), isFalse);
      // but fields should be preserved
      expect(stored.type, original.type);
      expect(stored.isFootlong, original.isFootlong);
      expect(stored.breadType, original.breadType);
    });

    test('add with quantity > 1 adds multiple sandwiches', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(s, quantity: 3);
      expect(cart.count, 3);
      expect(cart.sandwiches.length, 3);
      for (final item in cart.sandwiches) {
        expect(item.type, s.type);
        expect(item.isFootlong, s.isFootlong);
        expect(item.breadType, s.breadType);
      }
    });

    test('add with non-positive quantity does nothing', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );

      cart.add(s, quantity: 0);
      cart.add(s, quantity: -2);
      expect(cart.count, 0);
      expect(cart.sandwiches, isEmpty);
    });

    test('remove returns false if given an instance that is not in the cart',
        () {
      final cart = Cart();
      final original = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.add(original);
      // Because Cart.add creates copies, removing the original (different instance)
      // should return false.
      final removedOriginal = cart.remove(original);
      expect(removedOriginal, isFalse);
      expect(cart.count, 1);
    });

    test('remove returns true and removes when passed the stored instance', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.add(s);
      final stored = cart.sandwiches.first;
      final result = cart.remove(stored);
      expect(result, isTrue);
      expect(cart.count, 0);
      expect(cart.sandwiches, isEmpty);
    });

    test('removing one of multiple duplicates removes only one item', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );

      cart.add(s, quantity: 3);
      expect(cart.count, 3);

      // remove the middle stored instance
      final toRemove = cart.sandwiches[1];
      final removed = cart.remove(toRemove);
      expect(removed, isTrue);
      expect(cart.count, 2);
      // remaining items should still match original fields
      for (final item in cart.sandwiches) {
        expect(item.type, s.type);
        expect(item.isFootlong, s.isFootlong);
        expect(item.breadType, s.breadType);
      }
    });

    test('clear empties the cart', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.add(s, quantity: 2);
      expect(cart.count, 2);
      cart.clear();
      expect(cart.count, 0);
      expect(cart.sandwiches, isEmpty);
    });

    test('count getter reflects sandwiches.length', () {
      final cart = Cart();
      expect(cart.count, cart.sandwiches.length);

      cart.add(Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      ));
      expect(cart.count, cart.sandwiches.length);
    });
  });
}
