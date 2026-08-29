import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/complaint_model.dart';
import '../models/category_model.dart';
import '../models/profile_model.dart';
import '../models/update_model.dart';
import '../models/notification_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Auth
  User? get currentUser => _client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Profile
  Future<Profile?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return Profile.fromJson(data);
  }

  // Categories
  Future<List<ComplaintCategory>> getCategories() async {
    final data = await _client.from('complaint_categories').select().order('name');
    return (data as List).map((e) => ComplaintCategory.fromJson(e)).toList();
  }

  // Complaints
  Future<List<Complaint>> getMyComplaints() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('complaints')
        .select('*, complaint_categories(name)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (data as List).map((e) => Complaint.fromJson(e)).toList();
  }

  Future<List<Complaint>> getAllComplaints() async {
    final data = await _client
        .from('complaints')
        .select('*, complaint_categories(name), profiles(full_name)')
        .order('created_at', ascending: false);
    
    return (data as List).map((e) => Complaint.fromJson(e)).toList();
  }

  Future<Complaint> getComplaintDetails(String id) async {
    final data = await _client
        .from('complaints')
        .select('*, complaint_categories(name), profiles(full_name)')
        .eq('id', id)
        .single();
    return Complaint.fromJson(data);
  }

  Future<void> createComplaint(Complaint complaint, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }

    final complaintData = complaint.toJson();
    if (imageUrl != null) {
      complaintData['image_url'] = imageUrl;
    }

    await _client.from('complaints').insert(complaintData);
  }

  Future<void> updateComplaintStatus(String complaintId, ComplaintStatus status, String message) async {
    await _client.from('complaints').update({
      'status': status.name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', complaintId);

    await _client.from('complaint_updates').insert({
      'complaint_id': int.parse(complaintId),
      'status': status.name,
      'message': message,
      'updated_by': currentUser!.id,
    });
  }

  Future<void> assignComplaint(String complaintId, String adminId) async {
    await _client.from('complaints').update({
      'assigned_to': adminId,
      'status': ComplaintStatus.assigned.name,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', complaintId);

    await _client.from('complaint_updates').insert({
      'complaint_id': int.parse(complaintId),
      'status': ComplaintStatus.assigned.name,
      'message': 'Complaint assigned to an agent.',
      'updated_by': currentUser!.id,
    });
  }

  Future<List<ComplaintUpdate>> getComplaintUpdates(String complaintId) async {
    final data = await _client
        .from('complaint_updates')
        .select('*, profiles(full_name)')
        .eq('complaint_id', complaintId)
        .order('created_at', ascending: true);
    
    return (data as List).map((e) => ComplaintUpdate.fromJson(e)).toList();
  }

  // Storage
  Future<String?> uploadImage(File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = 'complaints/$fileName';
    
    await _client.storage.from('complaint_images').upload(path, file);
    
    return _client.storage.from('complaint_images').getPublicUrl(path);
  }

  // Notifications
  Future<List<AppNotification>> getNotifications() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (data as List).map((e) => AppNotification.fromJson(e)).toList();
  }

  Future<void> markNotificationAsRead(String id) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', id);
  }
  
  // Admin search/filter
  Future<List<Complaint>> searchComplaints(String query) async {
     final data = await _client
        .from('complaints')
        .select('*, complaint_categories(name), profiles(full_name)')
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .order('created_at', ascending: false);
    
    return (data as List).map((e) => Complaint.fromJson(e)).toList();
  }
}
