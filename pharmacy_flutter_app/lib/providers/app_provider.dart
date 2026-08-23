import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/profile.dart';
import '../services/supabase_service.dart';

class AppProvider with ChangeNotifier {
  final SupabaseService _supabase = SupabaseService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Medicine> _medicines = [];
  List<Medicine> get medicines => _medicines;

  List<MedicineCategory> _categories = [];
  List<MedicineCategory> get categories => _categories;

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Profile? _profile;
  Profile? get profile => _profile;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    setLoading(true);
    try {
      await Future.wait([
        fetchCategories(),
        fetchMedicines(),
        if (_supabase.currentUser != null) ...[
          fetchProfile(),
          fetchCartItems(),
          fetchOrders(),
        ]
      ]);
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    _categories = await _supabase.getCategories();
    notifyListeners();
  }

  Future<void> fetchMedicines({String? categoryId, String? searchQuery}) async {
    _medicines = await _supabase.getMedicines(categoryId: categoryId, searchQuery: searchQuery);
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    if (_supabase.currentUser == null) return;
    _profile = await _supabase.getProfile();
    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    if (_supabase.currentUser == null) return;
    _cartItems = await _supabase.getCartItems();
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    if (_supabase.currentUser == null) return;
    _orders = await _supabase.getOrders();
    notifyListeners();
  }

  double get cartTotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.medicine?.price ?? 0) * item.quantity);
  }

  Future<void> addToCart(String medicineId, int quantity) async {
    await _supabase.addToCart(medicineId, quantity);
    await fetchCartItems();
  }

  Future<void> updateCartQuantity(String cartItemId, int quantity) async {
    await _supabase.updateCartItemQuantity(cartItemId, quantity);
    await fetchCartItems();
  }

  Future<void> removeFromCart(String cartItemId) async {
    await _supabase.removeFromCart(cartItemId);
    await fetchCartItems();
  }

  Future<void> checkout() async {
    setLoading(true);
    try {
      await _supabase.placeOrder(_cartItems, cartTotal);
      _cartItems = [];
      await fetchOrders();
      await fetchMedicines(); // Refresh stock
    } finally {
      setLoading(false);
    }
  }
}
