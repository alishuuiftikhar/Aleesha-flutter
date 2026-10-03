import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';
import '../models/savings_model.dart';

class FinanceProvider with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  List<Category> _categories = [];
  List<TransactionModel> _transactions = [];
  List<Budget> _budgets = [];
  List<SavingsGoal> _savingsGoals = [];

  List<Category> get categories => _categories;
  List<TransactionModel> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  List<SavingsGoal> get savingsGoals => _savingsGoals;

  Future<void> fetchAll() async {
    await fetchCategories();
    await fetchTransactions();
    await fetchBudgets();
    await fetchSavingsGoals();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await _dbHelper.queryAll('categories');
      if (data.isNotEmpty) {
        _categories = data.map((item) => Category.fromMap(item)).toList();
      } else {
        _categories = _getDefaultCategories();
      }
    } catch (e) {
      debugPrint("DB Error, using fallback categories: $e");
      _categories = _getDefaultCategories();
    }
    notifyListeners();
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(id: 1, name: 'Food', icon: 'fastfood', color: 0xFFE9C46A),
      Category(id: 2, name: 'Transport', icon: 'directions_car', color: 0xFF527B8A),
      Category(id: 3, name: 'Shopping', icon: 'shopping_bag', color: 0xFF355070),
      Category(id: 4, name: 'Entertainment', icon: 'movie', color: 0xFFE76F51),
      Category(id: 5, name: 'Health', icon: 'medical_services', color: 0xFF2A9D8F),
      Category(id: 6, name: 'Education', icon: 'school', color: 0xFF264653),
      Category(id: 7, name: 'Salary', icon: 'payments', color: 0xFF8AB17D),
      Category(id: 8, name: 'Investment', icon: 'trending_up', color: 0xFFE9C46A),
    ];
  }

  Future<void> fetchTransactions() async {
    try {
      final data = await _dbHelper.queryAll('transactions');
      _transactions = data.map((item) => TransactionModel.fromMap(item)).toList();
    } catch (e) {
      debugPrint("Transactions fetch failed: $e");
    }
    notifyListeners();
  }

  Future<void> fetchBudgets() async {
    try {
      final data = await _dbHelper.queryAll('budgets');
      _budgets = data.map((item) => Budget.fromMap(item)).toList();
    } catch (e) {
      debugPrint("Budgets fetch failed: $e");
    }
    notifyListeners();
  }

  Future<void> fetchSavingsGoals() async {
    try {
      final data = await _dbHelper.queryAll('savings_goals');
      _savingsGoals = data.map((item) => SavingsGoal.fromMap(item)).toList();
    } catch (e) {
      debugPrint("Savings goals fetch failed: $e");
    }
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    TransactionModel toAdd = transaction;
    try {
      int id = await _dbHelper.insert('transactions', transaction.toMap());
      toAdd = TransactionModel(
        id: id,
        title: transaction.title,
        amount: transaction.amount,
        date: transaction.date,
        categoryId: transaction.categoryId,
        type: transaction.type,
        note: transaction.note,
      );
    } catch (e) {
      debugPrint("DB Insert failed, using in-memory: $e");
      // For Web, assign a fake ID based on timestamp
      if (toAdd.id == null) {
        toAdd = TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch,
          title: transaction.title,
          amount: transaction.amount,
          date: transaction.date,
          categoryId: transaction.categoryId,
          type: transaction.type,
          note: transaction.note,
        );
      }
    }
    _transactions.insert(0, toAdd);
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await _dbHelper.delete('transactions', id);
    } catch (e) {
      debugPrint("DB Delete failed: $e");
    }
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    Budget toAdd = budget;
    try {
      int id = await _dbHelper.insert('budgets', budget.toMap());
      toAdd = Budget(
        id: id,
        categoryId: budget.categoryId,
        limitAmount: budget.limitAmount,
        month: budget.month,
      );
    } catch (e) {
      debugPrint("DB Budget insert failed: $e");
      if (toAdd.id == null) {
        toAdd = Budget(
          id: DateTime.now().millisecondsSinceEpoch,
          categoryId: budget.categoryId,
          limitAmount: budget.limitAmount,
          month: budget.month,
        );
      }
    }
    _budgets.add(toAdd);
    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _dbHelper.update('budgets', budget.toMap());
    } catch (e) {
      debugPrint("DB Budget update failed: $e");
    }
    int index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) _budgets[index] = budget;
    notifyListeners();
  }

  Future<void> deleteBudget(int id) async {
    try {
      await _dbHelper.delete('budgets', id);
    } catch (e) {
      debugPrint("DB Budget delete failed: $e");
    }
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    SavingsGoal toAdd = goal;
    try {
      int id = await _dbHelper.insert('savings_goals', goal.toMap());
      toAdd = SavingsGoal(
        id: id,
        title: goal.title,
        targetAmount: goal.targetAmount,
        currentAmount: goal.currentAmount,
        deadline: goal.deadline,
      );
    } catch (e) {
      debugPrint("DB Savings insert failed: $e");
      if (toAdd.id == null) {
        toAdd = SavingsGoal(
          id: DateTime.now().millisecondsSinceEpoch,
          title: goal.title,
          targetAmount: goal.targetAmount,
          currentAmount: goal.currentAmount,
          deadline: goal.deadline,
        );
      }
    }
    _savingsGoals.add(toAdd);
    notifyListeners();
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    try {
      await _dbHelper.update('savings_goals', goal.toMap());
    } catch (e) {
      debugPrint("DB Savings update failed: $e");
    }
    int index = _savingsGoals.indexWhere((g) => g.id == goal.id);
    if (index != -1) _savingsGoals[index] = goal;
    notifyListeners();
  }

  Future<void> deleteSavingsGoal(int id) async {
    try {
      await _dbHelper.delete('savings_goals', id);
    } catch (e) {
      debugPrint("DB Savings delete failed: $e");
    }
    _savingsGoals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  double get totalIncome {
    return _transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get balance => totalIncome - totalExpenses;

  double getSpentByCategory(int categoryId, String month) {
    return _transactions
        .where((t) =>
            t.categoryId == categoryId &&
            t.type == 'expense' &&
            DateFormat('yyyy-MM').format(t.date) == month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
