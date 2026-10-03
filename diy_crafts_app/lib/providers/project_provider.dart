import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/craft_project.dart';

class ProjectProvider with ChangeNotifier {
  List<CraftProject> _projects = [];
  List<CraftProject> _userProjects = [];
  bool _isLoading = true;

  List<CraftProject> get allProjects => [..._projects, ..._userProjects];
  List<CraftProject> get favorites => allProjects.where((p) => p.isFavorite).toList();
  bool get isLoading => _isLoading;

  ProjectProvider() {
    loadProjects();
  }

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load initial data from JSON
      final String response = await rootBundle.loadString('assets/data/projects.json');
      final List<dynamic> data = json.decode(response);
      _projects = data.map((json) => CraftProject.fromJson(json)).toList();

      // Load user projects and modifications from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      // Load favorites, completed status, notes, progress for base projects
      for (var project in _projects) {
        project.isFavorite = prefs.getBool('fav_${project.id}') ?? project.isFavorite;
        project.isCompleted = prefs.getBool('comp_${project.id}') ?? project.isCompleted;
        project.notes = prefs.getString('notes_${project.id}') ?? project.notes;
        project.progress = prefs.getDouble('prog_${project.id}') ?? project.progress;
      }

      // Load custom user projects
      final String? userProjectsJson = prefs.getString('user_projects');
      if (userProjectsJson != null) {
        final List<dynamic> userData = json.decode(userProjectsJson);
        _userProjects = userData.map((json) => CraftProject.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error loading projects: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final project = allProjects.firstWhere((p) => p.id == id);
    project.isFavorite = !project.isFavorite;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fav_$id', project.isFavorite);
    
    if (project.isUserCreated) {
      await _saveUserProjects();
    }
    
    notifyListeners();
  }

  Future<void> updateProjectStatus(String id, {bool? isCompleted, double? progress, String? notes}) async {
    final project = allProjects.firstWhere((p) => p.id == id);
    if (isCompleted != null) project.isCompleted = isCompleted;
    if (progress != null) project.progress = progress;
    if (notes != null) project.notes = notes;

    final prefs = await SharedPreferences.getInstance();
    if (isCompleted != null) await prefs.setBool('comp_$id', project.isCompleted);
    if (progress != null) await prefs.setDouble('prog_$id', project.progress);
    if (notes != null) await prefs.setString('notes_$id', project.notes);

    if (project.isUserCreated) {
      await _saveUserProjects();
    }

    notifyListeners();
  }

  Future<void> addProject(CraftProject project) async {
    _userProjects.add(project);
    await _saveUserProjects();
    notifyListeners();
  }

  Future<void> updateProject(CraftProject updatedProject) async {
    if (updatedProject.isUserCreated) {
      final index = _userProjects.indexWhere((p) => p.id == updatedProject.id);
      if (index != -1) {
        _userProjects[index] = updatedProject;
        await _saveUserProjects();
      }
    } else {
       final index = _projects.indexWhere((p) => p.id == updatedProject.id);
       if (index != -1) {
         _projects[index] = updatedProject;
         // We don't save the whole _projects list back to JSON (assets are read-only)
         // but we save its state to prefs as we do in updateProjectStatus
       }
    }
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    _userProjects.removeWhere((p) => p.id == id);
    await _saveUserProjects();
    notifyListeners();
  }

  Future<void> _saveUserProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_userProjects.map((p) => p.toJson()).toList());
    await prefs.setString('user_projects', encodedData);
  }

  List<CraftProject> searchProjects(String query) {
    if (query.isEmpty) return allProjects;
    return allProjects.where((p) => 
      p.title.toLowerCase().contains(query.toLowerCase()) || 
      p.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<CraftProject> filterByCategory(String category) {
    if (category == 'All') return allProjects;
    return allProjects.where((p) => p.category == category).toList();
  }
}
