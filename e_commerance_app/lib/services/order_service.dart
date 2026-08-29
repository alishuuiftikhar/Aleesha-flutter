import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  OrderService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // Create Order
  static Future<void> createOrder({
    required String userId,
    required double totalAmount,
    required String status,
    required String fullName,
    required String phone,
    required String address,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      // 1. Insert order and get the ID
      final orderResponse = await _supabase.from('orders').insert({
        'user_id': userId,
        'total_amount': totalAmount,
        'status': status,
        'full_name': fullName,
        'phone': phone,
        'address': address,
        'payment_method': paymentMethod,
      }).select().single();

      final orderId = orderResponse['id'];

      // 2. Insert order items
      final orderItems = items.map((item) {
        final product = item['products'];
        return {
          'order_id': orderId,
          'product_id': product['id'],
          'quantity': item['quantity'],
          'price': product['price'],
        };
      }).toList();

      await _supabase.from('order_items').insert(orderItems);
      
      // 3. Clear cart after successful order
      await _supabase.from('cart').delete().eq('user_id', userId);
    } catch (e) {
      print("ORDER CREATION ERROR: $e");
      throw Exception("Order save nahi ho saka: $e");
    }
  }

  // Get Orders
  static Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("GET ORDERS ERROR: $e");
      return [];
    }
  }

  // Cancel Order
  static Future<void> cancelOrder(int orderId) async {
    await _supabase
        .from('orders')
        .update({'status': 'Cancelled'})
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
