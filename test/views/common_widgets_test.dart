import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/models/cart.dart';

void main() {
  

  testWidgets('AppBar displays title and cart count', (WidgetTester tester) async {
    final Cart cart = Cart();
    // add one item so count shows > 0
    // But Sandwich is required to add; instead rely on 0 initial count

    // Build a simple app and assert after pump.
    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>.value(
        value: cart,
        child: MaterialApp(
          home: Builder(builder: (context) {
            return Scaffold(appBar: Header.buildAppBar(context, title: 'Test Title'), body: const SizedBox.shrink());
          }),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Menu button opens endDrawer and shows default entries', (WidgetTester tester) async {
    final Cart cart = Cart();

    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>.value(
        value: cart,
        child: MaterialApp(
          home: Builder(builder: (context) {
            return Scaffold(appBar: Header.buildAppBar(context, title: 'Test'), endDrawer: Header.buildDrawer(context), body: const SizedBox.shrink());
          }),
        ),
      ),
    );

    // Drawer closed initially
    expect(find.text('Profile'), findsNothing);

    // Tap the menu icon to open endDrawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Default navigation entries should be visible
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Order History'), findsOneWidget);
  });

  testWidgets('Tapping Profile opens ProfileScreen', (WidgetTester tester) async {
    final Cart cart = Cart();

    await tester.pumpWidget(
      ChangeNotifierProvider<Cart>.value(
        value: cart,
        child: MaterialApp(
          home: Builder(builder: (context) {
            return Scaffold(appBar: Header.buildAppBar(context, title: 'Test'), endDrawer: Header.buildDrawer(context), body: const SizedBox.shrink());
          }),
        ),
      ),
    );

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // ProfileScreen contains 'Enter your details:'
    expect(find.textContaining('Enter your details'), findsOneWidget);
  });

  testWidgets('buildSideNav contains default entries', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        return Material(
          child: Row(children: [Header.buildSideNav(context), const Expanded(child: SizedBox.shrink())]),
        );
      }),
    ));

    // Side nav should show default labels
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Order History'), findsOneWidget);
  });
}
