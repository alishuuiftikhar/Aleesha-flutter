import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constants.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // Auth Operations
  static Future<AuthResponse> signUp(String email, String password, Map<String, dynamic> metadata) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
    
    if (response.user != null) {
      await client.from('profiles').insert({
        'id': response.user!.id,
        'full_name': metadata['full_name'],
        'role': metadata['role'],
      });
    }
    
    return response;
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Database Operations
  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await client.from('profiles').select().eq('id', userId).maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  static Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await client.from('profiles').update(data).eq('id', userId);
  }

  static Future<List<Map<String, dynamic>>> getJobs({String? categoryId, String? searchQuery}) async {
    var query = client.from('jobs').select('*, companies(*), job_categories(*)');
    
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('title', '%$searchQuery%');
    }
    
    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client.from('job_categories').select().order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> applyForJob(String jobId, String userId, String resumeUrl, String coverLetter) async {
    // Check if already applied
    final existing = await client.from('applications').select().eq('job_id', jobId).eq('user_id', userId);
    if (existing.isNotEmpty) {
      throw Exception('You have already applied for this job.');
    }

    await client.from('applications').insert({
      'job_id': jobId,
      'user_id': userId,
      'resume_url': resumeUrl,
      'cover_letter': coverLetter,
      'status': 'pending',
    });
  }

  static Future<List<Map<String, dynamic>>> getMyApplications(String userId) async {
    final response = await client
        .from('applications')
        .select('*, jobs(*, companies(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> toggleSaveJob(String jobId, String userId, bool isSaved) async {
    if (isSaved) {
      await client.from('saved_jobs').delete().eq('job_id', jobId).eq('user_id', userId);
    } else {
      await client.from('saved_jobs').insert({
        'job_id': jobId,
        'user_id': userId,
      });
    }
  }

  static Future<List<Map<String, dynamic>>> getSavedJobs(String userId) async {
    final response = await client
        .from('saved_jobs')
        .select('job_id, jobs(*, companies(*))')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  // Employer Operations
  static Future<List<Map<String, dynamic>>> getEmployerJobs(String companyId) async {
    final response = await client
        .from('jobs')
        .select('*, applications(count)')
        .eq('company_id', companyId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> createJob(Map<String, dynamic> jobData) async {
    await client.from('jobs').insert(jobData);
  }

  static Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    await client.from('jobs').update(jobData).eq('id', jobId);
  }

  static Future<void> deleteJob(String jobId) async {
    await client.from('jobs').delete().eq('id', jobId);
  }

  static Future<List<Map<String, dynamic>>> getJobApplications(String jobId) async {
    final response = await client
        .from('applications')
        .select('*, profiles(*)')
        .eq('job_id', jobId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<List<Map<String, dynamic>>> getEmployerAllApplications(String companyId) async {
    // Simplified query to ensure maximum compatibility and catch all apps
    final response = await client
        .from('applications')
        .select('*, profiles(*), jobs!inner(*)')
        .eq('jobs.company_id', companyId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> updateApplicationStatus(String applicationId, String status) async {
    await client.from('applications').update({'status': status}).eq('id', applicationId);
    
    // Notify user (simplified)
    final application = await client.from('applications').select('user_id, job_id').eq('id', applicationId).maybeSingle();
    if (application != null) {
      await client.from('notifications').insert({
        'user_id': application['user_id'],
        'title': 'Application Update',
        'message': 'Your application status has been updated to $status.',
        'type': 'application_update',
      });
    }
  }
}
