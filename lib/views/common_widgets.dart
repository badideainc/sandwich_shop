import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

class Header extends AppBar {
  Header({super.key});

  // Build an AppBar that provides a hamburger menu when a Drawer is available.
  static PreferredSizeWidget buildAppBar(BuildContext context,
      {String? title}) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      title: Text(
        title ?? 'Sandwich Shop',
        style: heading1,
      ),
      actions: [
        // Drawer button (kept in actions so the existing leading logo remains).
        Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: 'Open navigation',
          );
        }),
        Consumer<Cart>(
          builder: (context, cart, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 4),
                  Text('${cart.countOfItems}'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Build a Drawer widget driven by a routeLabels map: route -> label.
  static Widget buildDrawer(BuildContext context,
      {Map<String, String>? routeLabels}) {
    // Default navigation entries (only include implemented pages).
    final Map<String, String> defaultLabels = {
      '/': 'Home',
      '/profile': 'Profile',
      '/cart': 'Cart',
      '/checkout': 'Checkout',
      '/settings': 'Settings',
      '/order_history': 'Order History',
    };
    final Map<String, String> labels = routeLabels ?? defaultLabels;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              child: Center(
                child: SizedBox(
                  height: 72,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const FlutterLogo(size: 56);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: labels.entries.map((entry) {
                  final routeName = entry.key;
                  final label = entry.value;
                  return ListTile(
                    leading: _iconForRoute(routeName),
                    title: Text(label),
                    selected:
                        ModalRoute.of(context)?.settings.name == routeName,
                    onTap: () {
                      Navigator.of(context).pop();
                      final current = ModalRoute.of(context)?.settings.name;
                      if (current == routeName) return;

                      // Handle navigation for implemented pages.
                      if (routeName == '/profile') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/cart') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const CartScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/checkout') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/settings') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/order_history') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const OrderHistoryScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/') {
                        Navigator.pushReplacementNamed(context, routeName);
                      } else {
                        Navigator.pushNamed(context, routeName);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build a side navigation column for wide screens.
  static Widget buildSideNav(BuildContext context,
      {Map<String, String>? routeLabels}) {
    final Map<String, String> defaultLabels = {
      '/': 'Home',
      '/profile': 'Profile',
      '/cart': 'Cart',
      '/checkout': 'Checkout',
      '/settings': 'Settings',
      '/order_history': 'Order History',
    };
    final Map<String, String> labels = routeLabels ?? defaultLabels;

    return Container(
      width: 220,
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 72,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const FlutterLogo(size: 56);
                  },
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: labels.entries.map((entry) {
                  final routeName = entry.key;
                  final label = entry.value;
                  return ListTile(
                    leading: _iconForRoute(routeName),
                    title: Text(label),
                    selected:
                        ModalRoute.of(context)?.settings.name == routeName,
                    onTap: () {
                      final current = ModalRoute.of(context)?.settings.name;
                      if (current == routeName) return;

                      if (routeName == '/profile') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/cart') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const CartScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/checkout') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/settings') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/order_history') {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const OrderHistoryScreen(),
                          ),
                        );
                        return;
                      }

                      if (routeName == '/') {
                        Navigator.pushReplacementNamed(context, routeName);
                      } else {
                        Navigator.pushNamed(context, routeName);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Icon _iconForRoute(String route) {
    switch (route) {
      case '/about':
        return const Icon(Icons.info);
      case '/login':
        return const Icon(Icons.account_circle);
      case '/profile':
        return const Icon(Icons.person);
      case '/cart':
        return const Icon(Icons.shopping_cart);
      case '/checkout':
        return const Icon(Icons.payment);
      case '/settings':
        return const Icon(Icons.settings);
      case '/order_history':
        return const Icon(Icons.history);
      case '/':
      default:
        return const Icon(Icons.home);
    }
  }
}
