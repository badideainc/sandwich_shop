import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import 'package:sandwich_shop/models/saved_order.dart';

void main() {
  setUpAll(() {
    // Initialize ffi implementation for sqflite (already in dev deps)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Ensure a fresh database for each test
    final String databasesPath = await getDatabasesPath();
    final String dbPath = join(databasesPath, 'sandwich_shop.db');
    await deleteDatabase(dbPath);
  });

  testWidgets('shows loading indicator then empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderHistoryScreen()));

    // Should show loading indicator immediately after first frame
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let async DB load finish
    await tester.pumpAndSettle();

    // With no rows, screen should show empty message
    expect(find.text('No orders yet'), findsOneWidget);
  });

  testWidgets('displays saved orders from database',
      (WidgetTester tester) async {
    final dbService = DatabaseService();

    final SavedOrder order1 = SavedOrder(
      id: 0,
      orderId: 'ORD-001',
      totalAmount: 12.5,
      itemCount: 2,
      orderDate: DateTime(2025, 1, 2, 14, 5),
    );

    final SavedOrder order2 = SavedOrder(
      id: 0,
      orderId: 'ORD-002',
      totalAmount: 25.0,
      itemCount: 3,
      orderDate: DateTime(2025, 2, 3, 9, 30),
    );

    // Insert orders into the same database that OrderHistoryScreen will read
    await dbService.insertOrder(order1);
    await dbService.insertOrder(order2);

    await tester.pumpWidget(const MaterialApp(home: OrderHistoryScreen()));
    await tester.pumpAndSettle();

    // Check that order IDs and totals are visible
    expect(find.text('ORD-001'), findsOneWidget);
    expect(find.text('£12.50'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);

    expect(find.text('ORD-002'), findsOneWidget);
    expect(find.text('£25.00'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);

    // Verify formatted dates match the screen's formatter
    expect(find.text('2/1/2025 14:05'), findsOneWidget);
    expect(find.text('3/2/2025 9:30'), findsOneWidget);
  });
}
