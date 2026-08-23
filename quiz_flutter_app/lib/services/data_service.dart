import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category.dart';

class DataService {
  Future<List<Category>> loadCategories() async {
    final String response = await rootBundle.loadString('assets/data/questions.json');
    final data = await json.decode(response) as List;
    return data.map((c) => Category.fromJson(c)).toList();
  }
}
