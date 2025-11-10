import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadSandwichData() async {
  final String jsonString =
      await rootBundle.loadString('assets/sandwiches.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['sandwiches']);
}
