import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/maintenance.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_and_filter.dart';
import '../widgets/status_badge.dart';
import 'maintenance_form_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MaintenanceVisit> _maintenanceList = [];
  bool _isLoading = true;
  String _timeframe = 'All';
  String _statusFilter = 'All';
  String _serviceFilter = 'All';

  final List<String> _services = ['All', 'Plumbing', 'Electrical', 'Internet', 'AC', 'Cleaning', 'Repair', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllMaintenance(
      searchQuery: _searchController.text.trim(),
      filterStatus: _statusFilter,
      filterService: _serviceFilter,
      timeframe: _timeframe,
    );
    if (mounted) {
      setState(() {
        _maintenanceList = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(MaintenanceVisit item) async {
    await DatabaseHelper.instance.toggleMaintenanceFavorite(item);
    _loadData();
  }

  Future<void> _updateStatus(int id, String newStatus) async {
    await DatabaseHelper.instance.updateMaintenanceStatus(id, newStatus);
    _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maintenance status updated to $newStatus'), backgroundColor: AppTheme.success),
      );
    }
  }

  Future<void> _deleteItem(MaintenanceVisit item) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Delete Maintenance Record',
      content: 'Are you sure you want to delete maintenance visit for "${item.workerName}"?',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteMaintenance(item.id!);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maintenance record deleted'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'plumbing':
        return Icons.water_drop_outlined;
      case 'electrical':
        return Icons.bolt_outlined;
      case 'internet':
        return Icons.wifi_outlined;
      case 'ac':
        return Icons.ac_unit_outlined;
      case 'cleaning':
        return Icons.cleaning_services_outlined;
      case 'repair':
        return Icons.home_repair_service_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  void _showDetailSheet(MaintenanceVisit item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.mainBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Icon(_getServiceIcon(item.serviceType), color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.workerName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      Text(
                        '${item.serviceType} Service ${item.company.isNotEmpty ? "• ${item.company}" : ""}',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: item.status),
              ],
            ),
            const Divider(height: 24),
            if (item.purpose.isNotEmpty) _buildDetailItem(Icons.description, 'Service Purpose', item.purpose),
            _buildDetailItem(Icons.calendar_month, 'Appointment Date & Time', '${item.date} at ${item.time}'),
            if (item.apartment.isNotEmpty) _buildDetailItem(Icons.home, 'Apartment', item.apartment),
            if (item.phoneNumber.isNotEmpty) _buildDetailItem(Icons.phone, 'Technician Phone', item.phoneNumber),
            if (item.notes.isNotEmpty) _buildDetailItem(Icons.note_alt_outlined, 'Notes', item.notes),

            const SizedBox(height: 18),

            if (item.status != 'Completed')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _updateStatus(item.id!, 'Completed');
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark Service as Completed'),
                ),
              ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => MaintenanceFormScreen(item: item)),
                      );
                      if (res == true) _loadData();
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _deleteItem(item);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Visits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.secondaryBackground.withOpacity(0.4),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SearchAndFilterWidget(
                  searchController: _searchController,
                  onSearchChanged: (val) => _loadData(),
                  selectedTimeframe: _timeframe,
                  onTimeframeChanged: (tf) {
                    setState(() => _timeframe = tf);
                    _loadData();
                  },
                  selectedStatus: _statusFilter,
                  onStatusChanged: (st) {
                    setState(() => _statusFilter = st);
                    _loadData();
                  },
                  statuses: const ['All', 'Scheduled', 'In Progress', 'Completed', 'Cancelled'],
                ),
                const SizedBox(height: 8),
                // Service Type Horizontal Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text('Service: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.textDark)),
                      ..._services.map((svc) {
                        final isSelected = _serviceFilter == svc;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ChoiceChip(
                            label: Text(svc),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _serviceFilter = svc);
                                _loadData();
                              }
                            },
                            selectedColor: AppTheme.highlight,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textDark,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _maintenanceList.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.build_circle_outlined,
                        title: 'No Maintenance Visits',
                        description: 'No maintenance records match your current search or filter.',
                        actionLabel: 'Schedule Visit',
                        onActionPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MaintenanceFormScreen()),
                          );
                          if (res == true) _loadData();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          itemCount: _maintenanceList.length,
                          itemBuilder: (context, index) {
                            final item = _maintenanceList[index];
                            return CustomCard(
                              onTap: () => _showDetailSheet(item),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primary,
                                    child: Icon(_getServiceIcon(item.serviceType), color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.workerName,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                              ),
                                            ),
                                            StatusBadge(status: item.status),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.serviceType} • ${item.purpose.isNotEmpty ? item.purpose : "Maintenance"}',
                                          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${item.date} at ${item.time}',
                                          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      item.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: item.isFavorite ? AppTheme.accent : AppTheme.textMuted,
                                    ),
                                    onPressed: () => _toggleFavorite(item),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MaintenanceFormScreen()),
          );
          if (res == true) _loadData();
        },
        icon: const Icon(Icons.build_rounded),
        label: const Text('Schedule Visit'),
      ),
    );
  }
}
