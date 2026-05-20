import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyUsername = 'username';
  static const _keyCart = 'cart_ids';

  // Session
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }

  // Cart
  static Future<List<int>> getCartIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCart) ?? [];
    return list.map((e) => int.parse(e)).toList();
  }

  static Future<void> addToCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCart) ?? [];
    if (!list.contains(productId.toString())) {
      list.add(productId.toString());
      await prefs.setStringList(_keyCart, list);
    }
  }

  static Future<void> removeFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyCart) ?? [];
    list.remove(productId.toString());
    await prefs.setStringList(_keyCart, list);
  }

  static Future<bool> isInCart(int productId) async {
    final ids = await getCartIds();
    return ids.contains(productId);
  }
}
