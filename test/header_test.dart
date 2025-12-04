import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/header.dart';

void main() {
  final Map<String, String> routeLabels = {
    '/': 'Home',
    '/about': 'About',
    '/login': 'Account',
  };

  testWidgets('Drawer opens and shows menu items', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        drawer: Builder(
            builder: (ctx) =>
                Header.buildDrawer(ctx, routeLabels: routeLabels)),
        body: const Center(child: Text('Body')),
      ),
    ));

    // Open the drawer via the AppBar hamburger button
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('Tapping drawer item navigates to route', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
            appBar: AppBar(),
            drawer: Header.buildDrawer(context, routeLabels: routeLabels),
            body: const Center(child: Text('HomePage'))),
        '/about': (context) =>
            const Scaffold(body: Center(child: Text('AboutPage'))),
        '/login': (context) =>
            const Scaffold(body: Center(child: Text('LoginPage'))),
      },
    ));

    // Open drawer
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    // Tap the About entry
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('AboutPage'), findsOneWidget);
  });

  testWidgets('Side nav highlights active route', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/about',
      routes: {
        '/': (context) => const Scaffold(body: Center(child: Text('HomePage'))),
        '/about': (context) => Builder(builder: (context) {
              return Scaffold(
                body: Row(
                  children: [
                    Header.buildSideNav(context, routeLabels: routeLabels),
                    const Expanded(child: Center(child: Text('AboutPage'))),
                  ],
                ),
              );
            }),
        '/login': (context) =>
            const Scaffold(body: Center(child: Text('LoginPage'))),
      },
    ));

    await tester.pumpAndSettle();

    // Find the About ListTile and verify it's selected
    final Finder aboutTile = find.widgetWithText(ListTile, 'About');
    expect(aboutTile, findsOneWidget);
    final ListTile tileWidget = tester.widget<ListTile>(aboutTile);
    expect(tileWidget.selected, isTrue);
  });
}
