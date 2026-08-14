import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserRole { student, admin }

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  bool isApproved;
  int fines;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.isApproved = false,
    this.fines = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] == 'admin' ? UserRole.admin : UserRole.student,
      isApproved: map['is_approved'] ?? false,
      fines: map['fines'] ?? 0,
    );
  }
}

class Seat {
  final String id;
  final String label;
  final String zone;
  bool isReserved;
  String? reservedByUserId;

  Seat({
    required this.id,
    required this.label,
    required this.zone,
    this.isReserved = false,
    this.reservedByUserId,
  });

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id'].toString(),
      label: map['label'],
      zone: map['zone'],
      isReserved: map['is_reserved'] ?? false,
      reservedByUserId: map['reserved_by_user_id'],
    );
  }
}

class AppState extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  AppUser? currentUser;
  List<AppUser> allUsers = [];
  List<Seat> allSeats = [];
  TimeOfDay reservationDeadline = const TimeOfDay(hour: 10, minute: 0);

  AppState() {
    _init();
  }

  Future<void> _init() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      await fetchUserData(session.user.id);
    }
    await refreshData();
  }

  Future<void> refreshData() async {
    try {
      final seatsData = await _supabase.from('seats').select();
      allSeats = seatsData.map<Seat>((s) => Seat.fromMap(s)).toList();

      final usersData = await _supabase.from('profiles').select();
      allUsers = usersData.map<AppUser>((u) => AppUser.fromMap(u)).toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }
  }

  List<AppUser> get pendingApprovals =>
      allUsers.where((u) => !u.isApproved && u.role == UserRole.student).toList();

  List<AppUser> get approvedStudents =>
      allUsers.where((u) => u.isApproved && u.role == UserRole.student).toList();

  Future<String?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await fetchUserData(response.user!.id);
        await refreshData();
        return null; // Success
      }
      return "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> fetchUserData(String userId) async {
    try {
      final data = await _supabase.from('profiles').select().eq('id', userId).single();
      currentUser = AppUser.fromMap(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<String?> register(String name, String studentId, String email, String password, UserRole role) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (response.user != null) {
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'full_name': name,
            'email': email,
            'role': role == UserRole.admin ? 'admin' : 'student',
            'is_approved': role == UserRole.admin,
            'fines': 0,
          });
          await refreshData();
          return null; // Success
        } catch (dbError) {
          return "User created in Auth, but Profile failed: ${dbError.toString()}";
        }
      }
      return "Registration failed";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> approveUser(String userId) async {
    await _supabase.from('profiles').update({'is_approved': true}).eq('id', userId);
    await refreshData();
  }

  Future<void> reserveSeat(String seatId) async {
    if (currentUser == null) return;
    
    final now = TimeOfDay.now();
    if (now.hour > reservationDeadline.hour ||
        (now.hour == reservationDeadline.hour && now.minute > reservationDeadline.minute)) {
      return;
    }

    await _supabase.from('seats').update({
      'is_reserved': true,
      'reserved_by_user_id': currentUser!.id,
    }).eq('id', seatId);
    
    await refreshData();
  }

  void setDeadline(TimeOfDay time) {
    reservationDeadline = time;
    notifyListeners();
  }

  Future<void> markNoShow(String userId) async {
    final user = allUsers.firstWhere((u) => u.id == userId);
    await _supabase.from('profiles').update({'fines': user.fines + 15}).eq('id', userId);
    
    await _supabase.from('seats').update({
      'is_reserved': false,
      'reserved_by_user_id': null,
    }).eq('reserved_by_user_id', userId);
    
    await refreshData();
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
