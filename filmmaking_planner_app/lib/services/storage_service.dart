import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _projectsKey = 'filmmaking_projects';

  Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_projectsKey, encodedData);
  }

  Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_projectsKey);
    if (encodedData == null) return [];
    
    final List<dynamic> decodedData = jsonDecode(encodedData);
    return decodedData.map((p) => Project.fromJson(p)).toList();
  }
}
