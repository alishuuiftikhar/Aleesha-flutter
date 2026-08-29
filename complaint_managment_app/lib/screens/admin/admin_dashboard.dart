import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../../services/auth_provider.dart';
import '../../models/complaint_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/complaint_card.dart';
import '../profile_screen.dart';
import 'admin_complaint_details.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Complaint> _complaints = [];
  List<Complaint> _filteredComplaints = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() => _isLoading = true);
    try {
      final complaints = await _supabaseService.getAllComplaints();
      setState(() {
        _complaints = complaints;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredComplaints = _complaints.where((c) {
        final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (c.userName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
        final matchesStatus = _statusFilter == null || c.status.name == _statusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Total', _complaints.length.toString()),
                _buildStat('Pending', _complaints.where((c) => c.status == ComplaintStatus.pending).length.toString()),
                _buildStat('Active', _complaints.where((c) => c.status == ComplaintStatus.assigned || c.status == ComplaintStatus.inProgress).length.toString()),
                _buildStat('Resolved', _complaints.where((c) => c.status == ComplaintStatus.resolved).length.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search by title, desc, or user...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(null, 'All'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'Pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Assigned', 'Assigned'),
                const SizedBox(width: 8),
                _buildFilterChip('In Progress', 'In Progress'),
                const SizedBox(width: 8),
                _buildFilterChip('Resolved', 'Resolved'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadComplaints,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredComplaints.length,
                      itemBuilder: (context, index) {
                        final complaint = _filteredComplaints[index];
                        return ComplaintCard(
                          complaint: complaint,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminComplaintDetailsScreen(complaintId: complaint.id),
                              ),
                            );
                            if (result == true) _loadComplaints();
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildFilterChip(String? value, String label) {
    final isSelected = _statusFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _statusFilter = selected ? value : null;
          _applyFilters();
        });
      },
    );
  }
}
