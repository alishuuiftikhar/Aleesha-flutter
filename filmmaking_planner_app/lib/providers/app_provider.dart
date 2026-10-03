import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class AppProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Project> _projects = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get showFavoritesOnly => _showFavoritesOnly;

  List<Project> get filteredProjects {
    List<Project> filtered = _projects;
    if (_showFavoritesOnly) {
      filtered = filtered.where((p) => p.isFavorite).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
        p.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    return filtered;
  }

  AppProvider() {
    loadProjects();
  }

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();
    _projects = await _storageService.loadProjects();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleShowFavorites() {
    _showFavoritesOnly = !_showFavoritesOnly;
    notifyListeners();
  }

  Future<void> addProject(String name, String description) async {
    final newProject = Project(
      id: const Uuid().v4(),
      name: name,
      description: description,
    );
    _projects.add(newProject);
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      await _storageService.saveProjects(_projects);
      notifyListeners();
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _projects.indexWhere((p) => p.id == id);
    if (index != -1) {
      _projects[index].isFavorite = !_projects[index].isFavorite;
      await _storageService.saveProjects(_projects);
      notifyListeners();
    }
  }
  
  // Scene operations
  Future<void> addScene(String projectId, String title, String location) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    project.scenes.add(Scene(id: const Uuid().v4(), title: title, location: location));
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> updateScene(String projectId, Scene scene) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final sceneIndex = project.scenes.indexWhere((s) => s.id == scene.id);
    if (sceneIndex != -1) {
      project.scenes[sceneIndex] = scene;
      await _storageService.saveProjects(_projects);
      notifyListeners();
    }
  }

  Future<void> deleteScene(String projectId, String sceneId) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    project.scenes.removeWhere((s) => s.id == sceneId);
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }
  
  // Shot operations
  Future<void> addShot(String projectId, String sceneId, Shot shot) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final scene = project.scenes.firstWhere((s) => s.id == sceneId);
    scene.shots.add(shot);
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> updateShot(String projectId, String sceneId, Shot shot) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final scene = project.scenes.firstWhere((s) => s.id == sceneId);
    final shotIndex = scene.shots.indexWhere((sh) => sh.id == shot.id);
    if (shotIndex != -1) {
      scene.shots[shotIndex] = shot;
      await _storageService.saveProjects(_projects);
      notifyListeners();
    }
  }

  Future<void> deleteShot(String projectId, String sceneId, String shotId) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final scene = project.scenes.firstWhere((s) => s.id == sceneId);
    scene.shots.removeWhere((sh) => sh.id == shotId);
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> toggleShotCompletion(String projectId, String sceneId, String shotId) async {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final scene = project.scenes.firstWhere((s) => s.id == sceneId);
    final shot = scene.shots.firstWhere((sh) => sh.id == shotId);
    shot.isCompleted = !shot.isCompleted;
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }

  Future<void> clearAllProjects() async {
    _projects = [];
    await _storageService.saveProjects(_projects);
    notifyListeners();
  }
}
