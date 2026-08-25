import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';
import '../models/internship_model.dart';
import 'internship_details_screen.dart';
import 'add_edit_internship_screen.dart';

class InternshipListScreen extends StatefulWidget {
  const InternshipListScreen({super.key});

  @override
  State<InternshipListScreen> createState() => _InternshipListScreenState();
}

class _InternshipListScreenState extends State<InternshipListScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'All';
  final List<String> _statusOptions = ['All', 'Planned', 'Ongoing', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Internships'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditInternshipScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by position or company...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statusOptions.length,
              itemBuilder: (context, index) {
                final status = _statusOptions[index];
                final isSelected = _selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedStatus = status);
                    },
                    selectedColor: AppColors.primary.withOpacity(0.3),
                    checkmarkColor: AppColors.accent,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                final filteredList = provider.internships.where((internship) {
                  final company = provider.getCompanyById(internship.companyId);
                  final matchesSearch = internship.position.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      (company?.name.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
                  final matchesStatus = _selectedStatus == 'All' || internship.status == _selectedStatus;
                  return matchesSearch && matchesStatus;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work_off_outlined, size: 64, color: AppColors.secondaryBackground),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No internships found' : 'No results for "$_searchQuery"',
                          style: const TextStyle(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final internship = filteredList[index];
                    return _buildInternshipCard(context, internship, provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternshipCard(BuildContext context, Internship internship, AppProvider provider) {
    final company = provider.getCompanyById(internship.companyId);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternshipDetailsScreen(internship: internship),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          internship.position,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          company?.name ?? 'Unknown Company',
                          style: const TextStyle(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(internship.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    '${internship.startDate.year} - ${internship.endDate.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.business_center, size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Text(
                    internship.department,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Ongoing':
        color = AppColors.success;
        break;
      case 'Planned':
        color = AppColors.highlight;
        break;
      case 'Completed':
        color = AppColors.accent;
        break;
      case 'Cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.secondaryText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
