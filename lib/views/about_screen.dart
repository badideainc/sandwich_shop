import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 600;
    final Map<String, String> routeLabels = {
      '/': 'Home',
      '/about': 'About',
      '/login': 'Account',
    };

    final Widget content = const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome to Sandwich Shop!', style: heading2),
          SizedBox(height: 20),
          Text(
            'We are a family-owned business dedicated to serving the best sandwiches in town. ',
            style: normalText,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: Header.buildAppBar(context, title: 'About Us'),
      drawer:
          isWide ? null : Header.buildDrawer(context, routeLabels: routeLabels),
      body: isWide
          ? Row(
              children: [
                Header.buildSideNav(context, routeLabels: routeLabels),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }
}
