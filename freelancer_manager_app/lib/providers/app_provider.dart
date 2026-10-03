import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/models.dart';
import 'dart:async';

class AppProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Client> _clients = [];
  
  List<Project> get projects => _projects;
  List<Client> get clients => _clients;

  final DatabaseHelper _db = DatabaseHelper.instance;

  AppProvider() {
    refreshData();
  }

  Future<void> refreshData() async {
    _projects = await _db.getProjects();
    _clients = await _db.getClients();
    notifyListeners();
  }

  // Projects
  Future<void> addProject(Project project) async {
    await _db.insert('projects', project.toMap());
    await refreshData();
  }

  Future<void> updateProject(Project project) async {
    await _db.update('projects', project.toMap());
    await refreshData();
  }

  Future<void> deleteProject(int id) async {
    await _db.delete('projects', id);
    await refreshData();
  }

  // Clients
  Future<void> addClient(Client client) async {
    await _db.insert('clients', client.toMap());
    await refreshData();
  }

  Future<void> updateClient(Client client) async {
    await _db.update('clients', client.toMap());
    await refreshData();
  }

  Future<void> deleteClient(int id) async {
    await _db.delete('clients', id);
    await refreshData();
  }

  // Tasks
  Future<List<Task>> getTasks(int projectId) => _db.getTasks(projectId);
  Future<void> addTask(Task task) async {
    await _db.insert('tasks', task.toMap());
    notifyListeners();
  }
  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      projectId: task.projectId,
      title: task.title,
      description: task.description,
      isCompleted: !task.isCompleted,
      priority: task.priority,
      deadline: task.deadline,
    );
    await _db.update('tasks', updatedTask.toMap());
    notifyListeners();
  }
  Future<void> deleteTask(int id) async {
    await _db.delete('tasks', id);
    notifyListeners();
  }

  // Expenses
  Future<List<Expense>> getExpenses(int projectId) => _db.getExpenses(projectId);
  Future<void> addExpense(Expense expense) async {
    await _db.insert('expenses', expense.toMap());
    notifyListeners();
  }
  Future<void> deleteExpense(int id) async {
    await _db.delete('expenses', id);
    notifyListeners();
  }

  // Notes
  Future<List<Note>> getNotes(int projectId) => _db.getNotes(projectId);
  Future<void> addNote(Note note) async {
    await _db.insert('notes', note.toMap());
    notifyListeners();
  }
  Future<void> deleteNote(int id) async {
    await _db.delete('notes', id);
    notifyListeners();
  }

  // Time Tracking
  TimeEntry? _activeEntry;
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

  TimeEntry? get activeEntry => _activeEntry;
  Duration get currentDuration => _currentDuration;

  void startTimer(int projectId) {
    if (_activeEntry != null) return;
    
    _activeEntry = TimeEntry(
      projectId: projectId,
      startTime: DateTime.now(),
      description: 'Working on project',
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDuration = DateTime.now().difference(_activeEntry!.startTime);
      notifyListeners();
    });
  }

  Future<void> stopTimer() async {
    if (_activeEntry == null) return;

    final entry = TimeEntry(
      projectId: _activeEntry!.projectId,
      startTime: _activeEntry!.startTime,
      endTime: DateTime.now(),
      description: _activeEntry!.description,
    );

    await _db.insert('time_entries', entry.toMap());
    _activeEntry = null;
    _timer?.cancel();
    _currentDuration = Duration.zero;
    notifyListeners();
  }

  Future<List<TimeEntry>> getTimeEntries(int projectId) => _db.getTimeEntries(projectId);

  // Statistics
  double getTotalEarnings() {
    return _projects.fold(0.0, (sum, item) => sum + item.budget);
  }

  Future<double> getTotalExpenses() async {
    final allExpenses = await _db.queryAllRows('expenses');
    return allExpenses.fold<double>(0.0, (sum, item) => sum + (item['amount'] as num).toDouble());
  }
  
  Future<double> getProjectProgress(int projectId) async {
    final tasks = await _db.getTasks(projectId);
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }
}
