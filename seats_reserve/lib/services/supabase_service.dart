import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:seats_reserve/models/user_profile.dart';
import 'package:seats_reserve/models/seat.dart';
import 'package:seats_reserve/models/reservation.dart';
import 'package:seats_reserve/models/fine.dart';
import 'package:seats_reserve/models/settings.dart';
import 'package:seats_reserve/models/app_notification.dart';
import 'package:seats_reserve/models/announcement.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // AUTH
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;

  // PROFILE
  Future<UserProfile?> getProfile(String id) async {
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();
      if (data == null) return null;
      return UserProfile.fromMap(data);
    } catch (e) {
      debugPrint('Error getting profile: $e');
      return null;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _supabase
        .from('profiles')
        .update(profile.toMap())
        .eq('id', profile.id);
  }

  Future<List<UserProfile>> getPendingStudents() async {
    final List data = await _supabase
        .from('profiles')
        .select('*, added_by_profiles:added_by(full_name)')
        .eq('role', 'student')
        .eq('status', 'pending');
    return data.map((e) => UserProfile.fromMap(e)).toList();
  }

  Future<List<UserProfile>> getApprovedStudents() async {
    final List data = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'student')
        .eq('status', 'approved');
    return data.map((e) => UserProfile.fromMap(e)).toList();
  }

  Future<void> updateStudentStatus(String id, String status) async {
    await _supabase
        .from('profiles')
        .update({'status': status})
        .eq('id', id);
  }

  Future<void> registerStudentByStudent({
    required String fullName,
    required String email,
    required String phone,
    required String studentId,
    required String course,
    required String addedBy,
  }) async {
    const uuid = Uuid();
    await _supabase.from('profiles').insert({
      'id': uuid.v4(),
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'student_id': studentId,
      'course': course,
      'role': 'student',
      'status': 'pending',
      'added_by': addedBy,
    });
  }

  Future<List<UserProfile>> getMyAddedStudents(String studentId) async {
    final List data = await _supabase
        .from('profiles')
        .select()
        .eq('added_by', studentId)
        .order('created_at', ascending: false);
    return data.map((e) => UserProfile.fromMap(e)).toList();
  }

  // SEATS
  Future<List<Seat>> getSeats() async {
    // 1. Get current limit from settings
    final settings = await getSettings();
    
    // 2. Fetch all seats but limit the result to settings.totalSeats
    final List data = await _supabase
        .from('seats')
        .select()
        .order('seat_number', ascending: true)
        .limit(settings.totalSeats);
        
    return data.map((e) => Seat.fromMap(e)).toList();
  }

  // RESERVATIONS
  Future<List<Reservation>> getTodayReservations() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final List data = await _supabase
        .from('reservations')
        .select('*, profiles(*), seats(*)')
        .eq('reservation_date', today);
    return data.map((e) => Reservation.fromMap(e)).toList();
  }

  Future<Reservation?> getStudentTodayReservation(String studentId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final data = await _supabase
        .from('reservations')
        .select('*, profiles(*), seats(*)')
        .eq('student_id', studentId)
        .eq('reservation_date', today)
        .maybeSingle();
    return data != null ? Reservation.fromMap(data) : null;
  }

  Future<List<Reservation>> getStudentAllReservations(String studentId) async {
    final today = DateTime.now().toIso8601String().split('T')[0]; // Not used but keeps context
    final List data = await _supabase
        .from('reservations')
        .select('*, profiles(*), seats(*)')
        .eq('student_id', studentId)
        .order('reservation_date', ascending: false);
    return data.map((e) => Reservation.fromMap(e)).toList();
  }

  Future<void> createReservation(String studentId, int seatId) async {
    await _supabase.from('reservations').insert({
      'student_id': studentId,
      'seat_id': seatId,
    });
  }

  Future<void> updateReservationStatus(String reservationId, String status) async {
    await _supabase
        .from('reservations')
        .update({'status': status})
        .eq('id', reservationId);
  }

  // FINES
  Future<void> createFine(String studentId, String reservationId, double amount, String reason) async {
    await _supabase.from('fines').insert({
      'student_id': studentId,
      'reservation_id': reservationId,
      'amount': amount,
      'reason': reason,
    });
  }

  Future<List<Fine>> getStudentFines(String studentId) async {
    final List data = await _supabase
        .from('fines')
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);
    return data.map((e) => Fine.fromMap(e)).toList();
  }

  Future<void> markFineAsPaid(String fineId) async {
    await _supabase.from('fines').update({
      'status': 'paid',
      'paid_at': DateTime.now().toIso8601String(),
    }).eq('id', fineId);
  }

  Future<List<Map<String, dynamic>>> getAllFines() async {
    final List data = await _supabase
        .from('fines')
        .select('*, profiles(full_name, student_id)')
        .order('created_at', ascending: false);
    return data.cast<Map<String, dynamic>>();
  }

  // SETTINGS
  Future<AppSettings> getSettings() async {
    try {
      final List data = await _supabase
          .from('software_house_settings')
          .select()
          .order('id', ascending: true);
      
      if (data.isNotEmpty) {
        return AppSettings.fromMap(data.first);
      }
    } catch (e) {
      debugPrint('Error getting settings: $e');
    }
    // Return hardcoded default if DB is totally empty
    return AppSettings(
      id: 1,
      houseName: 'SeatSync',
      totalSeats: 30,
      reservationDeadline: '10:00:00',
      fineAmount: 200.0,
      openingTime: '09:00:00',
      closingTime: '18:00:00',
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    try {
      final data = settings.toMap();
      data['id'] = 1; // Force ID 1 to ensure we always update the same row
      await _supabase
          .from('software_house_settings')
          .upsert(data);
          
      // Automatically ensure enough seat records exist in the 'seats' table
      await _ensureSeatsExist(settings.totalSeats);
    } catch (e) {
      debugPrint('Error updating settings: $e');
      rethrow;
    }
  }

  Future<void> _ensureSeatsExist(int requiredCount) async {
    try {
      final List existing = await _supabase.from('seats').select('id');
      final currentCount = existing.length;

      if (requiredCount > currentCount) {
        final List<Map<String, dynamic>> newSeats = [];
        for (int i = currentCount + 1; i <= requiredCount; i++) {
          newSeats.add({
            'seat_number': 'Seat ${i.toString().padLeft(2, '0')}',
            'status': 'available',
          });
        }
        await _supabase.from('seats').insert(newSeats);
      }
    } catch (e) {
      debugPrint('Error creating extra seats: $e');
    }
  }

  // REPORTS
  Future<List<Reservation>> getReservationsByDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];
    final List data = await _supabase
        .from('reservations')
        .select('*, profiles(*), seats(*)')
        .eq('reservation_date', dateStr);
    return data.map((e) => Reservation.fromMap(e)).toList();
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final List reservations = await _supabase.from('reservations').select('status');
    final List profiles = await _supabase.from('profiles').select('role, status');
    return {
      'reservations': reservations,
      'profiles': profiles,
    };
  }

  // SERVER TIME
  Future<DateTime> getServerTime() async {
    try {
      final response = await _supabase.rpc('get_server_time');
      return DateTime.parse(response);
    } catch (e) {
      return DateTime.now();
    }
  }

  // ANNOUNCEMENTS
  Future<List<Announcement>> getAnnouncements() async {
    final List data = await _supabase
        .from('announcements')
        .select()
        .eq('status', 'published')
        .order('created_at', ascending: false);
    return data.map((e) => Announcement.fromMap(e)).toList();
  }

  Future<void> createAnnouncement(Announcement announcement) async {
    await _supabase.from('announcements').insert(announcement.toMap());
  }

  Future<void> updateAnnouncement(String id, Map<String, dynamic> data) async {
    await _supabase.from('announcements').update(data).eq('id', id);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _supabase.from('announcements').delete().eq('id', id);
  }

  // ADVANCED ANALYTICS
  Future<Map<String, dynamic>> getAnalytics(String range) async {
    final now = DateTime.now();
    DateTime startDate;
    if (range == 'week') {
      startDate = now.subtract(const Duration(days: 7));
    } else if (range == 'month') {
      startDate = DateTime(now.year, now.month, 1);
    } else {
      startDate = DateTime(now.year, now.month, now.day);
    }

    final dateStr = startDate.toIso8601String().split('T')[0];

    final reservations = await _supabase
        .from('reservations')
        .select('*, profiles(full_name), seats(seat_number)')
        .gte('reservation_date', dateStr);
    
    final fines = await _supabase
        .from('fines')
        .select()
        .gte('created_at', dateStr);

    return {
      'reservations': reservations,
      'fines': fines,
    };
  }

  // STORAGE
  Future<String?> uploadProfileImage(File file, String userId) async {
    await _supabase.storage.from('profiles').upload(
      '$userId/profile.png',
      file,
      fileOptions: const FileOptions(upsert: true),
    );
    return _supabase.storage.from('profiles').getPublicUrl('$userId/profile.png');
  }

  // NOTIFICATIONS
  Future<List<AppNotification>> getNotifications(String userId) async {
    final List data = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data.map((e) => AppNotification.fromMap(e)).toList();
  }

  Future<void> markNotificationAsRead(String id) async {
    await _supabase.from('notifications').update({'is_read': true}).eq('id', id);
  }

  Future<void> createNotification(String userId, String title, String message) async {
    await _supabase.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'message': message,
    });
  }

  // PASSWORD
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }
}
