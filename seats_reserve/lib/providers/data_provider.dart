import 'package:flutter/material.dart';
import 'package:seats_reserve/services/supabase_service.dart';
import 'package:seats_reserve/models/seat.dart';
import 'package:seats_reserve/models/reservation.dart';
import 'package:seats_reserve/models/settings.dart';
import 'package:seats_reserve/models/fine.dart';
import 'package:seats_reserve/models/user_profile.dart';
import 'package:seats_reserve/models/app_notification.dart';
import 'package:seats_reserve/models/announcement.dart';

class DataProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Seat> _seats = [];
  List<Reservation> _todayReservations = [];
  AppSettings? _settings;
  List<Fine> _myFines = [];
  Reservation? _myTodayReservation;
  List<Reservation> _myAllReservations = [];
  List<UserProfile> _pendingStudents = [];
  List<UserProfile> _approvedStudents = [];
  List<Announcement> _announcements = [];
  Map<String, dynamic> _analytics = {};
  DateTime? _serverTime;
  List<Map<String, dynamic>> _allFines = [];

  List<Seat> get seats => _seats;
  List<Reservation> get todayReservations => _todayReservations;
  AppSettings? get settings => _settings;
  List<Fine> get myFines => _myFines;
  Reservation? get myTodayReservation => _myTodayReservation;
  List<Reservation> get myAllReservations => _myAllReservations;
  List<UserProfile> get pendingStudents => _pendingStudents;
  List<UserProfile> get approvedStudents => _approvedStudents;
  List<Announcement> get announcements => _announcements;
  Map<String, dynamic> get analytics => _analytics;
  DateTime? get serverTime => _serverTime;
  List<Map<String, dynamic>> get allFines => _allFines;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Optimized fetching - UI loads immediately, data follows
  Future<void> fetchInitialData(String? userId, String role) async {
    // Start showing placeholders instead of a full-screen loader
    _isLoading = true;
    notifyListeners();
    
    try {
      // Fetch only the most critical item first
      _settings = await _supabaseService.getSettings();
      
      // Stop blocking the UI as soon as settings are available
      _isLoading = false;
      notifyListeners();

      // Load everything else in parallel in the background
      Future.wait([
        _supabaseService.getSeats().then((value) => _seats = value),
        _supabaseService.getTodayReservations().then((value) => _todayReservations = value),
        _supabaseService.getAnnouncements().then((value) => _announcements = value),
        _supabaseService.getServerTime().then((value) => _serverTime = value),
      ]).then((_) => notifyListeners());

      if (role == 'admin') {
        _loadAdminData();
      } else if (userId != null) {
        _loadStudentData(userId);
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAdminData() async {
    try {
      _pendingStudents = await _supabaseService.getPendingStudents();
      _approvedStudents = await _supabaseService.getApprovedStudents();
      _analytics = await _supabaseService.getAnalytics('today');
      notifyListeners();
    } catch (e) {
      debugPrint('Admin background load failed: $e');
    }
  }

  Future<void> _loadStudentData(String userId) async {
    try {
      _myFines = await _supabaseService.getStudentFines(userId);
      _myTodayReservation = await _supabaseService.getStudentTodayReservation(userId);
      _myAllReservations = await _supabaseService.getStudentAllReservations(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Student background load failed: $e');
    }
  }

  Future<void> refreshAnnouncements() async {
    _announcements = await _supabaseService.getAnnouncements();
    notifyListeners();
  }

  Future<void> fetchAnalytics(String range) async {
    _analytics = await _supabaseService.getAnalytics(range);
    notifyListeners();
  }

  Future<void> fetchAllFines() async {
    _allFines = await _supabaseService.getAllFines();
    notifyListeners();
  }

  Future<void> payFine(String fineId) async {
    await _supabaseService.markFineAsPaid(fineId);
    await fetchAllFines();
    if (_myTodayReservation != null) {
      _myFines = await _supabaseService.getStudentFines(_myTodayReservation!.studentId);
    }
    notifyListeners();
  }

  Future<void> reserveSeat(String studentId, int seatId) async {
    await _supabaseService.createReservation(studentId, seatId);
    _myTodayReservation = await _supabaseService.getStudentTodayReservation(studentId);
    _myAllReservations = await _supabaseService.getStudentAllReservations(studentId);
    _todayReservations = await _supabaseService.getTodayReservations();
    notifyListeners();
  }

  Future<void> markAttendance(String reservationId, String status, double fineAmount) async {
    await _supabaseService.updateReservationStatus(reservationId, status);
    
    if (status == 'absent') {
      final res = _todayReservations.firstWhere((element) => element.id == reservationId);
      await _supabaseService.createFine(res.studentId, reservationId, fineAmount, 'Absent for reservation');
    }
    
    _todayReservations = await _supabaseService.getTodayReservations();
    notifyListeners();
  }

  List<Reservation> _reportReservations = [];
  List<AppNotification> _notifications = [];
  Map<String, dynamic> _stats = {};

  List<Reservation> get reportReservations => _reportReservations;
  List<AppNotification> get notifications => _notifications;
  Map<String, dynamic> get stats => _stats;

  Future<void> fetchReport(DateTime date) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reportReservations = await _supabaseService.getReservationsByDate(date);
    } catch (e) {
      debugPrint('Error fetching report: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNotifications(String userId) async {
    _notifications = await _supabaseService.getNotifications(userId);
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabaseService.markNotificationAsRead(notificationId);
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        userId: _notifications[index].userId,
        title: _notifications[index].title,
        message: _notifications[index].message,
        isRead: true,
        createdAt: _notifications[index].createdAt,
      );
      notifyListeners();
    }
  }

  Future<void> fetchStats() async {
    _stats = await _supabaseService.getStatistics();
    notifyListeners();
  }

  Future<void> approveStudent(String studentId) async {
    await _supabaseService.updateStudentStatus(studentId, 'approved');
    await _supabaseService.createNotification(studentId, 'Account Approved', 'Your account has been approved by admin. Please use the "Forgot Password" or "Set Password" flow to access your account.');
    _pendingStudents.removeWhere((element) => element.id == studentId);
    _approvedStudents = await _supabaseService.getApprovedStudents();
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    await _supabaseService.updateSettings(newSettings);
    _settings = newSettings;
    // Re-fetch seats to match the new total count immediately
    _seats = await _supabaseService.getSeats();
    notifyListeners();
  }

  Future<void> rejectStudent(String studentId) async {
    await _supabaseService.updateStudentStatus(studentId, 'rejected');
    _pendingStudents.removeWhere((element) => element.id == studentId);
    notifyListeners();
  }
}
