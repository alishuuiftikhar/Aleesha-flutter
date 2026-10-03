import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Auth
  User? get currentUser => _client.auth.currentUser;

  // Profiles
  Future<Map<String, dynamic>?> getProfile(String id) async {
    return await _client.from('profiles').select().eq('id', id).single();
  }

  // Products
  Future<List<Map<String, dynamic>>> getProducts() async {
    return await _client.from('products').select('*, product_categories(*)').order('name');
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    await _client.from('products').insert(product);
  }

  Future<void> updateProduct(String id, Map<String, dynamic> product) async {
    await _client.from('products').update(product).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // Categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    return await _client.from('product_categories').select().order('name');
  }

  // Materials
  Future<List<Map<String, dynamic>>> getMaterials() async {
    return await _client.from('materials').select('*, suppliers(*)').order('name');
  }

  Future<void> addMaterial(Map<String, dynamic> material) async {
    await _client.from('materials').insert(material);
  }

  Future<void> updateMaterial(String id, Map<String, dynamic> material) async {
    await _client.from('materials').update(material).eq('id', id);
  }

  // Production Orders
  Future<List<Map<String, dynamic>>> getProductionOrders() async {
    return await _client.from('production_orders').select('*, products(*)').order('created_at', ascending: false);
  }

  Future<void> createProductionOrder(Map<String, dynamic> order) async {
    await _client.from('production_orders').insert(order);
  }

  Future<bool> checkMaterialsAvailability(String productId, int quantity) async {
    final productMaterials = await _client.from('product_materials').select('*, materials(*)').eq('product_id', productId);
    
    for (var pm in productMaterials) {
      final requiredQty = pm['quantity'] * quantity;
      final material = pm['materials'];
      final currentQty = material['available_quantity'];
      
      if (currentQty < requiredQty) {
        return false;
      }
    }
    return true;
  }

  Future<void> updateProductionStatus(String id, String status) async {
    await _client.from('production_orders').update({'status': status}).eq('id', id);
    
    if (status == 'Completed') {
      await _handleProductionCompletion(id);
    }
  }

  Future<void> _handleProductionCompletion(String orderId) async {
    // Logic to reduce material inventory
    final order = await _client.from('production_orders').select('*, products(*)').eq('id', orderId).single();
    final productId = order['product_id'];
    final quantity = order['quantity'];

    final productMaterials = await _client.from('product_materials').select('*, materials(*)').eq('product_id', productId);

    for (var pm in productMaterials) {
      final materialId = pm['material_id'];
      final requiredQty = pm['quantity'] * quantity;
      
      final material = pm['materials'];
      final currentQty = material['available_quantity'];
      
      await _client.from('materials').update({
        'available_quantity': currentQty - requiredQty
      }).eq('id', materialId);
    }
  }

  // Suppliers
  Future<List<Map<String, dynamic>>> getSuppliers() async {
    return await _client.from('suppliers').select().order('name');
  }

  Future<void> addSupplier(Map<String, dynamic> supplier) async {
    await _client.from('suppliers').insert(supplier);
  }

  // Dashboard Stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    final productsRes = await _client.from('products').select('*');
    final activeOrdersRes = await _client.from('production_orders').select('*').filter('status', 'in', ['Scheduled', 'In Production', 'Paused']);
    final completedOrdersRes = await _client.from('production_orders').select('*').eq('status', 'Completed');
    final lowStockRes = await _client.from('materials').select('*');
    
    final lowStockCount = lowStockRes.where((m) => 
      (m['available_quantity'] ?? 0) < (m['minimum_stock_level'] ?? 0)).length;

    return {
      'total_products': productsRes.length,
      'active_orders': activeOrdersRes.length,
      'completed_orders': completedOrdersRes.length,
      'low_stock_materials': lowStockCount,
    };
  }
}
