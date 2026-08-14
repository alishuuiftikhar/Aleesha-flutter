import 'package:flutter/material.dart';
import '../models/food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({required this.foodItem, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      // Assuming price string is "Rs. 1,500"
      final price = double.parse(cartItem.foodItem.price.replaceAll('Rs. ', '').replaceAll(',', ''));
      total += price * cartItem.quantity;
    });
    return total;
  }

  void addItem(FoodItem foodItem) {
    if (_items.containsKey(foodItem.id)) {
      _items.update(
        foodItem.id,
        (existing) => CartItem(
          foodItem: existing.foodItem,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        foodItem.id,
        () => CartItem(foodItem: foodItem),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existing) => CartItem(
          foodItem: existing.foodItem,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
