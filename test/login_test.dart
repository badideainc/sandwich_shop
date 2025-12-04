import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/login_screen.dart';

void main() {
  Widget makeTestable({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  Widget makeTestableWithRoutes({required Widget loginScreen}) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/': (context) => const Scaffold(body: Center(child: Text('Home'))),
        '/login': (context) => loginScreen,
      },
    );
  }

  testWidgets('Login screen shows fields and buttons', (tester) async {
    await tester.pumpWidget(makeTestable(child: const LoginScreen()));

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Already have an account? Sign in'), findsOneWidget);
  });

  testWidgets('Submitting empty form shows validation errors', (tester) async {
    await tester.pumpWidget(makeTestable(child: const LoginScreen()));

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('Submitting invalid email shows email validation error',
      (tester) async {
    await tester.pumpWidget(makeTestable(child: const LoginScreen()));

    await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('Submitting valid form navigates to home', (tester) async {
    await tester
        .pumpWidget(makeTestableWithRoutes(loginScreen: const LoginScreen()));

    await tester.enterText(
        find.byType(TextFormField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
