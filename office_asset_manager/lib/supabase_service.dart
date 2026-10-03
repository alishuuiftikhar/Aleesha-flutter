import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Auth
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    
    if (response.user != null) {
      // Use upsert to avoid "duplicate key" error if a profile already exists
      // (e.g. created by a database trigger or previous attempt)
      await _client.from('profiles').upsert({
        'id': response.user!.id,
        'full_name': fullName,
        'email': email,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
    return response;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Assets
  Future<List<Asset>> getAssets() async {
    final response = await _client.from('assets').select().order('created_at');
    return (response as List).map((json) => Asset.fromJson(json)).toList();
  }

  Future<void> addAsset(Asset asset) async {
    await _client.from('assets').insert(asset.toJson());
  }

  Future<void> updateAsset(String id, Map<String, dynamic> data) async {
    await _client.from('assets').update(data).eq('id', id);
  }

  Future<void> deleteAsset(String id) async {
    await _client.from('assets').delete().eq('id', id);
  }

  // Categories
  Future<List<AssetCategory>> getCategories() async {
    final response = await _client.from('asset_categories').select();
    return (response as List).map((json) => AssetCategory.fromJson(json)).toList();
  }

  // Employees
  Future<List<Employee>> getEmployees() async {
    final response = await _client.from('employees').select();
    return (response as List).map((json) => Employee.fromJson(json)).toList();
  }

  // Assignments
  Future<void> assignAsset(String assetId, String employeeId) async {
    // Check if asset is already assigned
    final assetData = await _client.from('assets').select('status').eq('id', assetId).single();
    if (assetData['status'] == 'Assigned') {
      throw Exception('Asset is already assigned to another employee.');
    }

    await _client.from('asset_assignments').insert({
      'asset_id': assetId,
      'employee_id': employeeId,
      'assigned_at': DateTime.now().toIso8601String(),
    });
    await _client.from('assets').update({'assigned_to': employeeId, 'status': 'Assigned'}).eq('id', assetId);
  }

  Future<void> returnAsset(String assetId, String assignmentId) async {
    await _client.from('asset_assignments').update({
      'returned_at': DateTime.now().toIso8601String(),
    }).eq('id', assignmentId);
    await _client.from('assets').update({'assigned_to': null, 'status': 'Available'}).eq('id', assetId);
  }

  Future<List<AssetAssignment>> getAssetHistory(String assetId) async {
    final response = await _client
        .from('asset_assignments')
        .select('*, employees(full_name)')
        .eq('asset_id', assetId)
        .order('assigned_at', ascending: false);
    return (response as List).map((json) => AssetAssignment.fromJson(json)).toList();
  }

  // Maintenance
  Future<List<MaintenanceRecord>> getMaintenanceRecords() async {
    final response = await _client
        .from('maintenance_records')
        .select('*, assets(name)')
        .order('maintenance_date', ascending: false);
    return (response as List).map((json) => MaintenanceRecord.fromJson(json)).toList();
  }

  Future<void> addMaintenanceRecord(String assetId, String description, double cost) async {
    await _client.from('maintenance_records').insert({
      'asset_id': assetId,
      'description': description,
      'cost': cost,
      'maintenance_date': DateTime.now().toIso8601String(),
    });
    // Set asset status to Maintenance
    await _client.from('assets').update({'status': 'Maintenance'}).eq('id', assetId);
  }

  // Statistics
  Future<Map<String, int>> getDashboardStats() async {
    final assets = await _client.from('assets').select('status');
    int total = assets.length;
    int available = assets.where((a) => a['status'] == 'Available').length;
    int assigned = assets.where((a) => a['status'] == 'Assigned').length;
    int maintenance = assets.where((a) => a['status'] == 'Maintenance').length;

    return {
      'total': total,
      'available': available,
      'assigned': assigned,
      'maintenance': maintenance,
    };
  }
}
