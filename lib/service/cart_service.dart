import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static List<Map<String, dynamic>> _cartItems = [];
  static const String _cartKey = 'cartItems';
  static List<Map<String, dynamic>> get cartItems => _cartItems;
  static Future<void> loadCart() async {
    print('Loading cart from SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartKey);

    if (cartJson != null && cartJson.isNotEmpty) {
      try {
        _cartItems =
            (jsonDecode(cartJson) as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
        print('Cart loaded: ${_cartItems.length} items.');
      } catch (e) {
        print('Error decoding cart data from SharedPreferences: $e');
        _cartItems = [];
      }
    } else {
      _cartItems = [];
      print('No cart data found in SharedPreferences. Cart is empty.');
    }
  }

  static Future<void> _saveCart() async {
    print('Saving cart to SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();

    final String cartJson = jsonEncode(_cartItems);
    await prefs.setString(_cartKey, cartJson);
    print('Cart saved successfully.');
  }

  static void addItem(Map<String, dynamic> product) {
    final String? productId = product['product_id']?.toString();
    if (productId == null) {
      print(
        'Error: Product added to cart without a product_id. Cannot ensure uniqueness.',
      );

      return;
    }

    final existingItemIndex = _cartItems.indexWhere(
      (item) => item['product_id']?.toString() == productId,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex]['stock'] =
          (_cartItems[existingItemIndex]['stock'] as int? ?? 0) +
          (product['stock'] as int? ?? 1);
    } else {
      product['stock'] =
          (product['stock'] as int? ?? 0) > 0 ? (product['stock'] as int) : 1;
      _cartItems.add(Map<String, dynamic>.from(product));
    }
    _saveCart();
  }

  static void updateItemQuantity(
    Map<String, dynamic> product,
    int newQuantity,
  ) {
    final index = _cartItems.indexOf(product);
    if (index != -1) {
      if (newQuantity > 0) {
        _cartItems[index]['stock'] = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
      _saveCart();
    } else {
      print('Attempted to update quantity for a product not in cart.');
    }
  }

  static void removeItem(Map<String, dynamic> product) {
    _cartItems.remove(product);
    _saveCart();
  }

  static void clearCart() {
    _cartItems.clear();
  }
}
