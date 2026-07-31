import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  CartService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get Cart Items
  static Future<List<Map<String, dynamic>>> getCartItems(
      String userId) async {
    final response = await _supabase
        .from('cart')
        .select()
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  // Add To Cart
  static Future<void> addToCart({
    required String userId,
    required int productId,
    required int quantity,
  }) async {
    await _supabase.from('cart').insert({
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    });
  }

  // Update Quantity
  static Future<void> updateQuantity({
    required int cartId,
    required int quantity,
  }) async {
    await _supabase
        .from('cart')
        .update({
      'quantity': quantity,
    })
        .eq('id', cartId);
  }

  // Remove Item
  static Future<void> removeItem(int cartId) async {
    await _supabase
        .from('cart')
        .delete()
        .eq('id', cartId);
  }

  // Clear Cart
  static Future<void> clearCart(String userId) async {
    await _supabase
        .from('cart')
        .delete()
        .eq('user_id', userId);
  }
}