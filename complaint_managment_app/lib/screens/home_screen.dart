import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../models/complaint_model.dart';
import '../models/category_model.dart';
import '../theme/app_colors.dart';
import '../widgets/complaint_card.dart';
import 'create_complaint_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'complaint_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  List<Complaint> _complaints = [];
  List<Complaint> _filteredComplaints = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _statusFilter;
  String? _priorityFilter;
  String? _categoryFilter;
  List<ComplaintCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _supabaseService.getMyComplaints(),
        _supabaseService.getCategories(),
      ]);
      setState(() {
        _complaints = results[0] as List<Complaint>;
        _categories = results[1] as List<ComplaintCategory>;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadComplaints() async {
    try {
      final complaints = await _supabaseService.getMyComplaints();
      setState(() {
        _complaints = complaints;
        _applyFilters();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredComplaints = _complaints.where((c) {
        final matchesSearch = c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesStatus = _statusFilter == null || c.status.name == _statusFilter;
        final matchesPriority = _priorityFilter == null || c.priority == _priorityFilter;
        final matchesCategory = _categoryFilter == null || c.categoryId == _categoryFilter;
        return matchesSearch && matchesStatus && matchesPriority && matchesCategory;
      }).toList();
    });
  }

  Widget _buildFilterDropdown(String hint, String? value, List<String>? options, Function(String?) onChanged, {List<DropdownMenuItem<String>>? items}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          value: value,
          onChanged: onChanged,
          items: items ?? options?.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 12)))).toList(),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search complaints...',
                prefixIcon: const Icon(Icons.search),
                fillColor: AppColors.secondaryBackground.withOpacity(0.3),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterDropdown('Status', _statusFilter, ['Pending', 'Assigned', 'In Progress', 'Resolved', 'Closed'], (val) {
                  setState(() => _statusFilter = val);
                  _applyFilters();
                }),
                const SizedBox(width: 8),
                _buildFilterDropdown('Priority', _priorityFilter, ['Low', 'Medium', 'High', 'Urgent'], (val) {
                  setState(() => _priorityFilter = val);
                  _applyFilters();
                }),
                const SizedBox(width: 8),
                _buildFilterDropdown('Category', _categoryFilter, null, (val) {
                  setState(() => _categoryFilter = val);
                  _applyFilters();
                }, items: _categories.map((e) => DropdownMenuItem<String>(value: e.id, child: Text(e.name))).toList()),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _statusFilter = null;
                      _priorityFilter = null;
                      _categoryFilter = null;
                    });
                    _applyFilters();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadComplaints,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredComplaints.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_outlined, size: 64, color: AppColors.secondary.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text('No complaints found', style: TextStyle(color: AppColors.secondary)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredComplaints.length,
                          itemBuilder: (context, index) {
                            return ComplaintCard(
                              complaint: _filteredComplaints[index],
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ComplaintDetailsScreen(complaintId: _filteredComplaints[index].id),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateComplaintScreen()),
          );
          if (result == true) _loadComplaints();
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
