import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FurnitureItem {
  final String id;
  final String title;
  final String price;
  final String imageUrl;
  final String category;
  final String description;
  final List<String> colors;

  FurnitureItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.description = 'Beautiful handcrafted piece to elevate your home interior with elegance and style.',
    this.colors = const ['#F06292', '#FCE4EC', '#2D3436'],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
    'description': description,
    'colors': colors,
  };

  factory FurnitureItem.fromJson(Map<String, dynamic> json) => FurnitureItem(
    id: json['id'],
    title: json['title'],
    price: json['price'],
    imageUrl: json['imageUrl'],
    category: json['category'],
    description: json['description'],
    colors: List<String>.from(json['colors']),
  );
}

class OrderItem {
  final FurnitureItem item;
  final String userName;
  final String phone;
  final DateTime date;
  final String selectedColor;
  final String paymentMethod;

  OrderItem({
    required this.item,
    required this.userName,
    required this.phone,
    required this.date,
    required this.selectedColor,
    this.paymentMethod = 'Cash on Delivery',
  });
}

class AppData {
  static List<FurnitureItem> wishlist = [];
  static List<FurnitureItem> cart = [];
  static List<OrderItem> myOrders = [];
  
  static String? registeredEmail;
  static String? registeredPassword;
  static String? registeredName;
  static String? profilePicPath;
  static String? registeredBio;
  static bool isDarkMode = false;

  static Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(wishlist.map((item) => item.toJson()).toList());
    await prefs.setString('wishlist', encodedData);
  }

  static Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('wishlist');
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      wishlist = decodedData.map((item) => FurnitureItem.fromJson(item)).toList();
    }
  }

  static List<FurnitureItem> allItems = [
    // Modern
    FurnitureItem(id: 'm1', title: 'Pink Velvet Sofa', price: r'$520', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=500'),
    FurnitureItem(id: 'm2', title: 'Minimal Lamp', price: r'$140', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1507473884658-6605040f10c5?q=80&w=500'),
    FurnitureItem(id: 'm3', title: 'Modern Armchair', price: r'$320', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=500'),
    FurnitureItem(id: 'm4', title: 'Glass Table', price: r'$280', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?q=80&w=500'),
    FurnitureItem(id: 'm5', title: 'Abstract Art', price: r'$150', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=500'),
    FurnitureItem(id: 'm6', title: 'Grey Sectional', price: r'$890', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=500'),
    FurnitureItem(id: 'm7', title: 'Smart Desk', price: r'$450', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=500'),
    FurnitureItem(id: 'm8', title: 'Floor Mirror', price: r'$190', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1618220179428-22790b461013?q=80&w=500'),
    FurnitureItem(id: 'm9', title: 'Neon Clock', price: r'$65', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1563861826100-9cb868fdbe1c?q=80&w=500'),
    FurnitureItem(id: 'm10', title: 'Black Shelf', price: r'$210', category: 'Modern', imageUrl: 'https://images.unsplash.com/photo-1594620302200-9a762244a156?q=80&w=500'),

    // Classic
    FurnitureItem(id: 'c1', title: 'Royal Oak Bed', price: r'$1200', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1505693419148-ad3097f98751?q=80&w=500'),
    FurnitureItem(id: 'c2', title: 'Vintage Clock', price: r'$350', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1509114397022-ed747cca3f65?q=80&w=500'),
    FurnitureItem(id: 'c3', title: 'Leather Wingback', price: r'$750', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=500'),
    FurnitureItem(id: 'c4', title: 'Antique Desk', price: r'$980', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?q=80&w=500'),
    FurnitureItem(id: 'c5', title: 'Grand Chandelier', price: r'$1500', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1542728928-1413d1894ed1?q=80&w=500'),
    FurnitureItem(id: 'c6', title: 'Persian Rug', price: r'$600', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1575414003591-ece8d0416c7a?q=80&w=500'),
    FurnitureItem(id: 'c7', title: 'Wooden Dining', price: r'$1100', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1530018607912-eff2df114f23?q=80&w=500'),
    FurnitureItem(id: 'c8', title: 'Silver Mirror', price: r'$420', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=500'),
    FurnitureItem(id: 'c9', title: 'Bookshelf Cabinet', price: r'$850', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1594620302200-9a762244a156?q=80&w=500'),
    FurnitureItem(id: 'c10', title: 'Classic Vase', price: r'$120', category: 'Classic', imageUrl: 'https://images.unsplash.com/photo-1581783898377-1c85bf937427?q=80&w=500'),

    // Minimal
    FurnitureItem(id: 'min1', title: 'Zen Bed Frame', price: r'$400', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1505693314120-0d443867891c?q=80&w=500'),
    FurnitureItem(id: 'min2', title: 'Pure White Vase', price: r'$45', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d?q=80&w=500'),
    FurnitureItem(id: 'min3', title: 'Bamboo Stool', price: r'$75', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1503602642458-232111445657?q=80&w=500'),
    FurnitureItem(id: 'min4', title: 'Linear Shelf', price: r'$110', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1594620302200-9a762244a156?q=80&w=500'),
    FurnitureItem(id: 'min5', title: 'Paper Lantern', price: r'$35', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1507473884658-6605040f10c5?q=80&w=500'),
    FurnitureItem(id: 'min6', title: 'Grey Pouf', price: r'$90', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=500'),
    FurnitureItem(id: 'min7', title: 'Wood Block Table', price: r'$130', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?q=80&w=500'),
    FurnitureItem(id: 'min8', title: 'Slim Desk Lamp', price: r'$55', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1534073828943-f801091bb18c?q=80&w=500'),
    FurnitureItem(id: 'min9', title: 'Canvas Frame', price: r'$60', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=500'),
    FurnitureItem(id: 'min10', title: 'Simple Pegboard', price: r'$40', category: 'Minimal', imageUrl: 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=500'),

    // Luxury
    FurnitureItem(id: 'l1', title: 'Gold Velvet Bed', price: r'$3500', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1505693419148-ad3097f98751?q=80&w=500'),
    FurnitureItem(id: 'l2', title: 'Crystal Table', price: r'$2200', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?q=80&w=500'),
    FurnitureItem(id: 'l3', title: 'Marble Console', price: r'$1800', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=500'),
    FurnitureItem(id: 'l4', title: 'Silk Armchair', price: r'$1500', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=500'),
    FurnitureItem(id: 'l5', title: 'Gold Leaf Lamp', price: r'$900', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1507473884658-6605040f10c5?q=80&w=500'),
    FurnitureItem(id: 'l6', title: 'Diamond Mirror', price: r'$1200', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1618220179428-22790b461013?q=80&w=500'),
    FurnitureItem(id: 'l7', title: 'Designer Rug', price: r'$2500', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1575414003591-ece8d0416c7a?q=80&w=500'),
    FurnitureItem(id: 'l8', title: 'Onyx Coffee Table', price: r'$3000', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?q=80&w=500'),
    FurnitureItem(id: 'l9', title: 'Velvet Drapes', price: r'$700', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=500'),
    FurnitureItem(id: 'l10', title: 'Gold Sculpted Vase', price: r'$450', category: 'Luxury', imageUrl: 'https://images.unsplash.com/photo-1581783898377-1c85bf937427?q=80&w=500'),
  ];
}
