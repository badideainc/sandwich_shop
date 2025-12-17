import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end tests', () {
    setUp(() async {
      // Provide a mock implementation for shared_preferences so plugin calls
      // in `AppStyles.loadFontSize` don't throw during tests.
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues(<String, Object>{});

      // Initialize sqflite ffi for tests so DatabaseService can open DBs.
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      // Start the app before each test.
      app.main();
    });

    testWidgets('add a sandwich to the cart and verify cart summary',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Initial state
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);

      // Add a sandwich
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      if (addToCartButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(addToCartButton);
      }
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type then add to cart',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Open sandwich type dropdown and select a different sandwich
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      expect(sandwichDropdown, findsOneWidget);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add to cart and verify
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      if (addToCartButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(addToCartButton);
      }
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Open cart and verify the selected sandwich is present
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity then add to cart',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Increase quantity twice: locate the + inside the Quantity row and ensure it's visible.
      final Finder quantityRow = find.ancestor(
          of: find.text('Quantity: '), matching: find.byType(Row));
      expect(quantityRow, findsOneWidget);

      final Finder quantityAddButton =
          find.descendant(of: quantityRow, matching: find.byIcon(Icons.add));
      expect(quantityAddButton, findsOneWidget);

      // Ensure the quantity + button is visible (scrolls ancestors if needed)
      await tester.ensureVisible(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      // Verify quantity displayed
      expect(find.text('3'), findsOneWidget);

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      if (addToCartButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(addToCartButton);
      }
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary
      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow saves order and returns to home',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Add an item and go to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      if (addToCartButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(addToCartButton);
      }
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      if (viewCartButton.evaluate().isNotEmpty) {
        await tester.ensureVisible(viewCartButton);
      }
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Tap checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Confirm payment
      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);

      // Wait for processing to complete (Checkout waits ~2s)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('navigation controls exist (menu or on-page nav buttons)',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      final Finder menuButton = find.byIcon(Icons.menu);
      final Finder profileButton = find.widgetWithText(StyledButton, 'Profile');
      final Finder settingsButton =
          find.widgetWithText(StyledButton, 'Settings');
      final Finder orderHistoryButton =
          find.widgetWithText(StyledButton, 'Order History');

      final bool hasMenu = menuButton.evaluate().isNotEmpty;
      final bool hasProfile = profileButton.evaluate().isNotEmpty;
      final bool hasSettings = settingsButton.evaluate().isNotEmpty;
      final bool hasOrderHistory = orderHistoryButton.evaluate().isNotEmpty;

      expect(hasMenu || hasProfile || hasSettings || hasOrderHistory, isTrue,
          reason:
              'Expected at least one navigation entry: menu icon or on-page nav buttons.');
    });

    testWidgets('order history shows saved order after checkout',
        (WidgetTester tester) async {
      await tester.pumpAndSettle();

      // Add an item and complete checkout to ensure a saved order exists
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Open menu and navigate to Order History (tap if present, otherwise open programmatically).
      final Finder menuButton = find.byIcon(Icons.menu);
      if (menuButton.evaluate().isNotEmpty) {
        try {
          await tester.ensureVisible(menuButton.first);
          await tester.pumpAndSettle();
          await tester.tap(menuButton.first);
          await tester.pumpAndSettle();
        } catch (e) {
          final ScaffoldState scaffoldState =
              tester.state(find.byType(Scaffold).first) as ScaffoldState;
          scaffoldState.openEndDrawer();
          await tester.pumpAndSettle();
        }
      } else {
        final ScaffoldState scaffoldState =
            tester.state(find.byType(Scaffold).first) as ScaffoldState;
        scaffoldState.openEndDrawer();
        await tester.pumpAndSettle();
      }

      // Try to find a Drawer; if present, tap Order History inside it, otherwise
      // fall back to the on-page `StyledButton('Order History')`.
      final Finder drawerFinder = find.byType(Drawer);
      if (drawerFinder.evaluate().isNotEmpty) {
        final Finder orderHistoryTile = find.descendant(
            of: drawerFinder, matching: find.text('Order History'));
        expect(orderHistoryTile, findsWidgets);
        await tester.ensureVisible(orderHistoryTile.first);
        await tester.pumpAndSettle();
        await tester.tap(orderHistoryTile.first);
        await tester.pumpAndSettle();
      } else {
        final Finder orderHistoryButton =
            find.widgetWithText(StyledButton, 'Order History');
        expect(orderHistoryButton, findsOneWidget);
        await tester.ensureVisible(orderHistoryButton);
        await tester.pumpAndSettle();
        await tester.tap(orderHistoryButton);
        await tester.pumpAndSettle();
      }

      // Order History should display and show at least one order ("1 items")
      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('1 items'), findsWidgets);
    });
  });
}
