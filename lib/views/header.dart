import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class Header {
  // Build an AppBar that provides a hamburger menu when a Drawer is available.
  static PreferredSizeWidget buildAppBar(BuildContext context,
      {String? title}) {
    return AppBar(
      title: Text(title ?? 'Sandwich Shop', style: heading1),
    );
  }

  // Build a Drawer widget driven by a routeLabels map: route -> label.
  static Widget buildDrawer(BuildContext context,
      {Map<String, String>? routeLabels}) {
    final Map<String, String> labels = routeLabels ?? {'/': 'Home'};

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
    final Map<String, String> labels = routeLabels ?? {'/': 'Home'};

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
      case '/':
      default:
        return const Icon(Icons.home);
    }
  }
}
