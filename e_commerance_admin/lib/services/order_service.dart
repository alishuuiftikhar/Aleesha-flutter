import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderService {
  static final _supabase = Supabase.instance.client;

  static Future<List<OrderModel>> getOrders() async {
    // We use 'orders' table as defined in the SQL schema
    final data = await _supabase
        .from('orders')
        .select()
        .order('id', ascending: false);

    return (data as List)
        .map((e) => OrderModel.fromJson(e))
        .toList();
  }

  static Future<void> updateStatus(int id, String status) async {
    await _supabase
        .from('orders')
        .update({'status': status})
        .eq('id', id);
  }

  static Future<void> deleteOrder(int id) async {
    await _supabase
        .from('orders')
        .delete()
        .eq('id', id);
  }
}
