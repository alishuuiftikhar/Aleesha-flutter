import 'dart:async';
import '../models/medicine.dart';
import '../models/category.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/profile.dart';

class SupabaseService {
  // Mock Data
  static final List<MedicineCategory> _mockCategories = [
    MedicineCategory(id: '1', name: 'Painkillers', icon: 'medical_services'),
    MedicineCategory(id: '2', name: 'Antibiotics', icon: 'medication'),
    MedicineCategory(id: '3', name: 'Vitamins', icon: 'health_and_safety'),
    MedicineCategory(id: '4', name: 'First Aid', icon: 'home_repair_service'),
  ];

  static final List<Medicine> _mockMedicines = [
    Medicine(
      id: '1',
      name: 'Paracetamol',
      description: 'Effective for fever and mild to moderate pain.',
      price: 5.99,
      stock: 50,
      categoryId: '1',
      createdAt: DateTime.now(),
    ),
    Medicine(
      id: '2',
      name: 'Amoxicillin',
      description: 'Broad-spectrum antibiotic for various infections.',
      price: 12.50,
      stock: 20,
      categoryId: '2',
      createdAt: DateTime.now(),
    ),
    Medicine(
      id: '3',
      name: 'Vitamin C 1000mg',
      description: 'Boosts immune system and provides antioxidant support.',
      price: 8.99,
      stock: 100,
      categoryId: '3',
      createdAt: DateTime.now(),
    ),
    Medicine(
      id: '4',
      name: 'Band-Aid Box',
      description: 'Sterile bandages for minor cuts and scrapes.',
      price: 4.50,
      stock: 45,
      categoryId: '4',
      createdAt: DateTime.now(),
    ),
    Medicine(
      id: '5',
      name: 'Ibuprofen',
      description: 'Relieves inflammation and pain.',
      price: 7.25,
      stock: 30,
      categoryId: '1',
      createdAt: DateTime.now(),
    ),
  ];

  static Profile? _currentUserProfile = Profile(
    id: 'user123',
    fullName: 'Admin User',
    email: 'admin@pharmacy.com',
    phone: '+1234567890',
    address: '123 Medical St, Health City',
    isAdmin: true,
  );

  static final List<CartItem> _mockCartItems = [];
  static final List<OrderModel> _mockOrders = [];

  // Auth
  dynamic get currentUser => _currentUserProfile;
  
  // We'll simulate auth state changes with a simple controller if needed, 
  // but for mock, we just return the current state.
  Stream<dynamic> get authStateChanges => Stream.value(currentUser);

  Future<void> signUp(String email, String password, String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUserProfile = Profile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      isAdmin: false,
    );
  }

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simple mock logic: admin@pharmacy.com is admin
    _currentUserProfile = Profile(
      id: 'user123',
      fullName: email.split('@')[0],
      email: email,
      isAdmin: email == 'admin@pharmacy.com',
    );
  }

  Future<void> signOut() async {
    _currentUserProfile = null;
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Profile
  Future<Profile> getProfile() async {
    return _currentUserProfile!;
  }

  Future<void> updateProfile(Profile profile) async {
    _currentUserProfile = profile;
  }

  // Categories
  Future<List<MedicineCategory>> getCategories() async {
    return _mockCategories;
  }

  // Medicines
  Future<List<Medicine>> getMedicines({String? categoryId, String? searchQuery}) async {
    Iterable<Medicine> result = _mockMedicines;
    
    if (categoryId != null && categoryId != 'all') {
      result = result.where((m) => m.categoryId == categoryId);
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      result = result.where((m) => m.name.toLowerCase().contains(searchQuery.toLowerCase()));
    }

    return result.toList();
  }

  Future<Medicine> getMedicineDetails(String id) async {
    return _mockMedicines.firstWhere((m) => m.id == id);
  }

  // Admin Medicine Operations
  Future<void> addMedicine(Medicine medicine) async {
    _mockMedicines.add(Medicine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: medicine.name,
      description: medicine.description,
      price: medicine.price,
      stock: medicine.stock,
      categoryId: medicine.categoryId,
      imageUrl: medicine.imageUrl,
      createdAt: DateTime.now(),
    ));
  }

  Future<void> updateMedicine(String id, Map<String, dynamic> updates) async {
    final index = _mockMedicines.indexWhere((m) => m.id == id);
    if (index != -1) {
      final old = _mockMedicines[index];
      _mockMedicines[index] = Medicine(
        id: old.id,
        name: updates['name'] ?? old.name,
        description: updates['description'] ?? old.description,
        price: updates['price'] ?? old.price,
        stock: updates['stock'] ?? old.stock,
        categoryId: updates['category_id'] ?? old.categoryId,
        imageUrl: updates['image_url'] ?? old.imageUrl,
        createdAt: old.createdAt,
      );
    }
  }

  Future<void> deleteMedicine(String id) async {
    _mockMedicines.removeWhere((m) => m.id == id);
  }

  // Cart
  Future<List<CartItem>> getCartItems() async {
    return _mockCartItems;
  }

  Future<void> addToCart(String medicineId, int quantity) async {
    final index = _mockCartItems.indexWhere((item) => item.medicineId == medicineId);
    final medicine = _mockMedicines.firstWhere((m) => m.id == medicineId);

    if (index != -1) {
      final old = _mockCartItems[index];
      _mockCartItems[index] = CartItem(
        id: old.id,
        medicineId: old.medicineId,
        userId: old.userId,
        quantity: old.quantity + quantity,
        medicine: medicine,
      );
    } else {
      _mockCartItems.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicineId: medicineId,
        userId: _currentUserProfile?.id ?? 'guest',
        quantity: quantity,
        medicine: medicine,
      ));
    }
  }

  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    final index = _mockCartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (quantity <= 0) {
        _mockCartItems.removeAt(index);
      } else {
        final old = _mockCartItems[index];
        _mockCartItems[index] = CartItem(
          id: old.id,
          medicineId: old.medicineId,
          userId: old.userId,
          quantity: quantity,
          medicine: old.medicine,
        );
      }
    }
  }

  Future<void> removeFromCart(String cartItemId) async {
    _mockCartItems.removeWhere((item) => item.id == cartItemId);
  }

  // Orders
  Future<void> placeOrder(List<CartItem> items, double totalAmount) async {
    // 1. Check stock
    for (var item in items) {
      final medicine = _mockMedicines.firstWhere((m) => m.id == item.medicineId);
      if (medicine.stock < item.quantity) {
        throw Exception('Not enough stock for ${medicine.name}');
      }
    }

    // 2. Create Order
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: _currentUserProfile?.id ?? 'guest',
      totalAmount: totalAmount,
      status: 'Pending',
      createdAt: DateTime.now(),
      items: items.map((i) => OrderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderId: '',
        medicineId: i.medicineId,
        quantity: i.quantity,
        price: i.medicine!.price,
        medicine: i.medicine,
      )).toList(),
    );

    _mockOrders.add(order);

    // 3. Update Stock
    for (var item in items) {
      final index = _mockMedicines.indexWhere((m) => m.id == item.medicineId);
      final old = _mockMedicines[index];
      _mockMedicines[index] = Medicine(
        id: old.id,
        name: old.name,
        description: old.description,
        price: old.price,
        stock: old.stock - item.quantity,
        categoryId: old.categoryId,
        imageUrl: old.imageUrl,
        createdAt: old.createdAt,
      );
    }

    // 4. Clear Cart
    _mockCartItems.clear();
  }

  Future<List<OrderModel>> getOrders() async {
    return _mockOrders.reversed.toList();
  }

  // Admin Order Operations
  Future<List<OrderModel>> getAllOrders() async {
    return _mockOrders.reversed.toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final index = _mockOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final old = _mockOrders[index];
      _mockOrders[index] = OrderModel(
        id: old.id,
        userId: old.userId,
        totalAmount: old.totalAmount,
        status: status,
        createdAt: old.createdAt,
        items: old.items,
      );
    }
  }
}
