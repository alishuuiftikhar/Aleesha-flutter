import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistService {
  WishlistService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get Wishlist
  static Future<List<Map<String, dynamic>>> getWishlist(
      String userId) async {
    final response = await _supabase
        .from('wishlist')
        .select()
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  // Add To Wishlist
  static Future<void> addToWishlist({
    required String userId,
    required int productId,
  }) async {
    await _supabase.from('wishlist').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  // Remove From Wishlist
  static Future<void> removeFromWishlist({
    required String userId,
    required int productId,
  }) async {
    await _supabase
        .from('wishlist')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }
}