// lib/data/cart_data.dart

// import '../models/service_model.dart';

// List<VendorService> globalCartItems = [];

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';

List<VendorService> globalCartItems = [];

Future<void> saveCartToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String> cartJsonList =
      globalCartItems.map((item) => jsonEncode(item.toJson())).toList();
  await prefs.setStringList('cart_items', cartJsonList);
}

Future<void> loadCartFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? cartJsonList = prefs.getStringList('cart_items');
  if (cartJsonList != null) {
    globalCartItems =
        cartJsonList
            .map((item) => VendorService.fromJson(jsonDecode(item)))
            .toList();
  }
}

Future<void> clearCartFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('cart_items');
}
