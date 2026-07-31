import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  OrderService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // Create Order
  static Future<void> createOrder({
    required String userId,
    required double totalAmount,
    required String status,
  }) async {
    await _supabase.from('orders').insert({
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
    });
  }

  // Get Orders
  static Future<List<Map<String, dynamic>>> getOrders(
      String userId) async {
    final response = await _supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // Cancel Order
  static Future<void> cancelOrder(int orderId) async {
    await _supabase
        .from('orders')
        .update({
      'status': 'Cancelled',
    })
        .eq('id', orderId);
  }

  // Delete Order
  static Future<void> deleteOrder(int orderId) async {
    await _supabase
        .from('orders')
        .delete()
        .eq('id', orderId);
  }
}