import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../models/tutor_model.dart';
import '../models/subject_model.dart';
import '../models/booking_model.dart';
import '../models/availability_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Auth
  Future<AuthResponse> signUp(String email, String password, String fullName, String role) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': role},
    );
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  // Profiles
  Future<ProfileModel?> getProfile(String id) async {
    try {
      final data = await _client.from('profiles').select().eq('id', id).single();
      final profile = ProfileModel.fromJson(data);
      
      // Safety check: if role is tutor but no tutor record exists, create one
      if (profile.role == 'tutor') {
        try {
          final tutor = await _client.from('tutors').select().eq('profile_id', id).maybeSingle();
          if (tutor == null) {
            await _client.from('tutors').insert({
              'profile_id': id,
              'bio': 'Available for teaching classes.',
              'experience': 'Professional Tutor',
              'hourly_rate': 25.0,
            });
          }
        } catch (e) {
          debugPrint('Error ensuring tutor record: $e');
        }
      }
      return profile;
    } catch (e) {
      debugPrint('Supabase getProfile Error: $e');
      rethrow;
    }
  }

  // Tutors
  Future<List<TutorModel>> getTutors({String? query, int? subjectId, double? minRating}) async {
    var request = _client.from('tutors').select('*, profiles:profiles!tutors_profile_id_fkey(*), tutor_subjects(subjects(*))');
    
    if (subjectId != null) {
      // Filter by subject via junction table
      // This is a bit complex in Supabase JS/Dart client if not handled by RPC or specific join
      // We might need to fetch all and filter or use a better query
    }

    final List data = await request;
    return data.map((e) {
      // Map subjects from junction table
      var subjects = (e['tutor_subjects'] as List? ?? [])
          .map((ts) => SubjectModel.fromJson(ts['subjects']))
          .toList();
      var json = Map<String, dynamic>.from(e);
      json['subjects'] = subjects;
      return TutorModel.fromJson(json);
    }).toList();
  }

  Future<TutorModel?> getTutorById(String id) async {
    final data = await _client.from('tutors').select('*, profiles:profiles!tutors_profile_id_fkey(*), tutor_subjects(subjects(*))').eq('id', id).single();
    var subjects = (data['tutor_subjects'] as List? ?? [])
          .map((ts) => SubjectModel.fromJson(ts['subjects']))
          .toList();
    var json = Map<String, dynamic>.from(data);
    json['subjects'] = subjects;
    return TutorModel.fromJson(json);
  }

  // Subjects
  Future<List<SubjectModel>> getSubjects() async {
    final List data = await _client.from('subjects').select();
    return data.map((e) => SubjectModel.fromJson(e)).toList();
  }

  // Availability
  Future<List<AvailabilityModel>> getTutorAvailability(String tutorId) async {
    final List data = await _client.from('availability').select().eq('tutor_id', tutorId).eq('is_booked', false);
    return data.map((e) => AvailabilityModel.fromJson(e)).toList();
  }

  // Bookings
  Future<void> createBooking(BookingModel booking) async {
    // Check for double booking
    final existing = await _client.from('bookings')
        .select()
        .eq('tutor_id', booking.tutorId)
        .eq('booking_date', booking.bookingDate.toIso8601String().split('T')[0])
        .eq('start_time', booking.startTime)
        .eq('status', 'confirmed');
    
    if (existing.isNotEmpty) {
      throw Exception('This time slot is already booked.');
    }

    debugPrint('Inserting booking into DB: ${booking.studentId} -> ${booking.tutorId}');

    final response = await _client.from('bookings').insert({
      'student_id': booking.studentId,
      'tutor_id': booking.tutorId,
      'subject_id': booking.subjectId,
      'booking_date': booking.bookingDate.toIso8601String().split('T')[0],
      'start_time': booking.startTime,
      'end_time': booking.endTime,
      'status': 'pending',
      'total_price': booking.totalPrice,
      'student_name': booking.studentName,
      'student_phone': booking.studentPhone,
      'notes': booking.notes,
    }).select();

    debugPrint('Database Response: $response');
  }

  Future<List<BookingModel>> getMyBookings(String userId, bool isTutor) async {
    try {
      if (isTutor) {
        // 1. Tutor ke liye: Pehle uski real Tutor ID lein
        final tutorResult = await _client.from('tutors').select('id').eq('profile_id', userId);
        final List<String> tutorIds = tutorResult.map((e) => e['id'].toString()).toList();
        
        debugPrint('DEBUG: Dashboard searching for Tutor IDs: $tutorIds');

        // 2. Query ko robust banayein
        final List data = await _client.from('bookings')
            .select('*, subjects(*), tutors(*, profiles!tutors_profile_id_fkey(*))')
            .filter('tutor_id', 'in', '(${tutorIds.join(",")})')
            .order('booking_date', ascending: false);
            
        debugPrint('DEBUG: Found ${data.length} bookings for dashboard');
        return data.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        // 3. Student ke liye
        final List data = await _client.from('bookings')
            .select('*, subjects(*), tutors(*, profiles!tutors_profile_id_fkey(*))')
            .eq('student_id', userId)
            .order('booking_date', ascending: false);
        return data.map((e) => BookingModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('SUPABASE ERROR in getMyBookings: $e');
      // Emergency Fallback
      try {
        final List data = await _client.from('bookings').select('*, subjects(*)').order('booking_date');
        return data.map((e) => BookingModel.fromJson(e)).toList();
      } catch (_) { return []; }
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _client.from('bookings').update({'status': status}).eq('id', bookingId);
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    await _client.from('profiles').update({'role': newRole}).eq('id', userId);
    
    // If switching to tutor, ensure a tutor record exists
    if (newRole == 'tutor') {
      final existing = await _client.from('tutors').select().eq('profile_id', userId).maybeSingle();
      if (existing == null) {
        await _client.from('tutors').insert({
          'profile_id': userId,
          'bio': 'New tutor profile',
          'experience': 'Experienced in various subjects',
          'hourly_rate': 20.0,
        });
      }
    }
  }

  // Favorites
  Future<void> toggleFavorite(String studentId, String tutorId, bool isFav) async {
    if (isFav) {
      await _client.from('favorites').insert({'student_id': studentId, 'tutor_id': tutorId});
    } else {
      await _client.from('favorites').delete().eq('student_id', studentId).eq('tutor_id', tutorId);
    }
  }

  Future<List<String>> getFavoriteTutorIds(String studentId) async {
    final List data = await _client.from('favorites').select('tutor_id').eq('student_id', studentId);
    return data.map((e) => e['tutor_id'] as String).toList();
  }
}
