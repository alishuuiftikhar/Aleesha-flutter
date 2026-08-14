import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/product.dart';
import '../database/db_helper.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _allPets = [];
  List<Pet> _filteredPets = [];
  List<Product> _products = [];
  String _selectedCategory = 'All Pets';
  String _searchQuery = '';
  String _userName = 'enter your name';
  String _phoneNumber = '';
  String _paymentMethod = 'Cash on Delivery';

  List<Pet> get allPets => _allPets;
  List<Pet> get filteredPets => _filteredPets.where((p) => !p.isAdopted).toList();
  List<Product> get products => _products;
  String get selectedCategory => _selectedCategory;
  String get userName => _userName;
  String get phoneNumber => _phoneNumber;
  String get paymentMethod => _paymentMethod;

  PetProvider() {
    loadInitialData();
  }

  void _loadFallbackData() {
    // 15 Unique Dogs
    final dogIds = [
      '1517849845537-4d257902454a', '1583511655857-d19b40a7a54e', '1537151608828-ea2b11777ee8', '1583337130417-3346a1be7dee',
      '1512723185835-0700e5069a9a', '1561037404-61cd46aa615b', '1507146426996-ef05306b995a', '1530281700549-e82e7bf110d6',
      '1552053831-71594a27632d', '1543466835-00a7907e9ef1', '1518717758536-85ae29035b6d', '1589941013453-ec89f33b5e95',
      '1544568100-847a948585b9', '1583511655826-05700d52f4d9', '1516734212186-a967f81ad0d7'
    ];
    final dogNames = ['Max', 'Bella', 'Charlie', 'Luna', 'Rocky', 'Daisy', 'Cooper', 'Milo', 'Bailey', 'Lucy', 'Buddy', 'Bear', 'Sadie', 'Tucker', 'Zoe'];
    final dogBreeds = ['Golden Retriever', 'Poodle', 'Beagle', 'Husky', 'Bulldog', 'Dachshund', 'Labrador', 'Shih Tzu', 'Cocker Spaniel', 'Chihuahua', 'German Shepherd', 'Chow Chow', 'Boxer', 'French Bulldog', 'Pomeranian'];

    _allPets = List.generate(15, (i) => Pet(
      id: i, name: dogNames[i], breed: dogBreeds[i], age: '${(i%3)+1} years', distance: '${(i*0.4+0.5).toStringAsFixed(1)} km', 
      category: 'Dogs', imagePath: 'https://images.unsplash.com/photo-${dogIds[i]}?q=80&w=500', description: 'Friendly dog.'
    ));

    // 15 Unique Cats
    final catIds = [
      '1514888286974-6c03e2ca1dba', '1495360010541-f48722b34f7d', '1533738363-b7f9aef128ce', '1526336024174-e58f5cdd8e13',
      '1573865662567-57ef8b34518e', '1519052537078-e6302a4968d4', '1511495284982-442c22956c7d', '1548247416-ec66f4900b2e',
      '1533743983669-94fa5c4338ec', '1513245543132-31f507417b26', '1517331156700-3c241d2b4d83', '1529778873920-4da4926a72c2',
      '1535241639428-102607ba479e', '1501820488136-72669149e0d4', '1518791841217-8f162f1e1131'
    ];
    _allPets.addAll(List.generate(15, (i) => Pet(
      id: i + 15, name: 'Cat ${i+1}', breed: i % 2 == 0 ? 'Persian' : 'Siamese', age: '${(i%2)+1} years', distance: '${(i*0.3+1.2).toStringAsFixed(1)} km', 
      category: 'Cats', imagePath: 'https://images.unsplash.com/photo-${catIds[i]}?q=80&w=500', description: 'Lovely cat.'
    )));

    // 15 Unique Birds
    final birdIds = [
      '1522926193341-e9fed6c10e8f', '1444464666168-49d633b86797', '1552728089-57bdde30ebe3', '1516233501032-2485dc1cc6a2',
      '1452570053594-1b985d6ea890', '1548366086-7f1b76106622', '1618331835717-801e976710b2', '1555000395-8828277bc593',
      '1480044965905-02098d419e96', '1551085254-e96b210db58a', '1544158934-842ca07b5936', '1517101724602-c257fe568127',
      '1470619549108-b85c56fe5be8', '1550159930-40066082a4fc', '1520808663317-647b476a81b9'
    ];
    _allPets.addAll(List.generate(15, (i) => Pet(
      id: i + 30, name: 'Bird ${i+1}', breed: i % 2 == 0 ? 'Parrot' : 'Canary', age: '${(i%5)+1} months', distance: '${(i*0.2+0.8).toStringAsFixed(1)} km', 
      category: 'Birds', imagePath: 'https://images.unsplash.com/photo-${birdIds[i]}?q=80&w=500', description: 'Chirpy bird.'
    )));

    final prodIds = ['1589924691106-073b697596cd', '1601758228041-f3b2795255f1', '1585503418537-88331351ad99', '1568640347023-a616a30bc3bd', '1541781774459-bb2af2f05b55', '1591769225440-811ad7d6eca3', '1583337130417-3346a1be7dee', '1583337130417-3346a1be7dee', '1581447100512-67508112595b', '1583511655857-d19b40a7a54e', '1560743641-3914f2c45636', '1597843786271-290022f46261', '1583512603805-3cc6b41f3edb', '1516453174212-618467df23d6', '1583336663277-620dc1996580', '1583512603866-910c8542ba18', '1583337130417-3346a1be7dee', '1583511655857-d19b40a7a54e', '1583336663277-620dc1996580', '1583512603866-910c8542ba18'];
    _products = List.generate(20, (i) {
      String cat = (i < 7) ? 'Dog Food' : (i < 14 ? 'Cat Food' : 'Bird Food');
      return Product(
        id: i, name: 'Premium ${cat} Pack ${i+1}', brand: 'PetPal Nutri', price: '\$${(i+1)*4}.99', 
        imagePath: 'https://images.unsplash.com/photo-${prodIds[i]}?q=80&w=500',
        category: cat, description: 'Best nutrition.'
      );
    });
  }

  Future<void> loadInitialData() async {
    _loadFallbackData(); // Load default first
    try {
      final dbPets = await DatabaseHelper.instance.getAllPets();
      if (dbPets.isNotEmpty) {
        _allPets = dbPets;
      }
      final productData = await DatabaseHelper.instance.getAllProducts();
      if (productData.isNotEmpty) {
        _products = productData.map((m) => Product.fromMap(m)).toList();
      }
    } catch (e) {
      debugPrint("DB Check: Using fallback data for Web/Mock.");
    }
    _applyFilters();
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredPets = _allPets.where((pet) {
      final matchesCategory = _selectedCategory == 'All Pets' || pet.category == _selectedCategory;
      final matchesSearch = pet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet.breed.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> toggleFavorite(Pet pet) async {
    final newFavoriteStatus = !pet.isFavorite;
    try {
      await DatabaseHelper.instance.toggleFavorite(pet.id!, newFavoriteStatus);
    } catch (e) {
      debugPrint("DB Sync skipped on Web.");
    }
    
    final index = _allPets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _allPets[index] = pet.copyWith(isFavorite: newFavoriteStatus);
      _applyFilters();
      notifyListeners();
    }
  }

  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void updatePhoneNumber(String newNumber) {
    _phoneNumber = newNumber;
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<void> adoptPet(Pet pet) async {
    final index = _allPets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _allPets[index] = pet.copyWith(isAdopted: true);
      _applyFilters();
      notifyListeners();
    }
  }

  List<Pet> get favoritePets => _allPets.where((pet) => pet.isFavorite).toList();
  List<Pet> get adoptedPets => _allPets.where((pet) => pet.isAdopted).toList();
}
