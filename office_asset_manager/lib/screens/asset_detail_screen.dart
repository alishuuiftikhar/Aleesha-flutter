import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';
import 'add_edit_asset_screen.dart';

class AssetDetailScreen extends StatefulWidget {
  final String assetId;
  const AssetDetailScreen({super.key, required this.assetId});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  Asset? _asset;
  List<AssetAssignment> _history = [];
  List<MaintenanceRecord> _maintenanceRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final supabaseService = context.read<SupabaseService>();
      final assets = await supabaseService.getAssets();
      _asset = assets.firstWhere((a) => a.id == widget.assetId);
      _history = await supabaseService.getAssetHistory(widget.assetId);
      
      final mRecords = await supabaseService.getMaintenanceRecords();
      _maintenanceRecords = mRecords.where((r) => r.assetId == widget.assetId).toList();

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAsset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: const Text('Are you sure you want to delete this asset? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<SupabaseService>().deleteAsset(widget.assetId);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _assignAsset() async {
    final employees = await context.read<SupabaseService>().getEmployees();
    if (!mounted) return;

    final employeeId = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Asset'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final emp = employees[index];
              return ListTile(
                title: Text(emp.fullName),
                subtitle: Text(emp.email),
                onTap: () => Navigator.pop(context, emp.id),
              );
            },
          ),
        ),
      ),
    );

    if (employeeId != null) {
      try {
        await context.read<SupabaseService>().assignAsset(widget.assetId, employeeId);
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _returnAsset() async {
    if (_asset?.status != 'Assigned' || _history.isEmpty) return;
    
    final currentAssignment = _history.firstWhere((h) => h.returnedAt == null);

    try {
      await context.read<SupabaseService>().returnAsset(widget.assetId, currentAssignment.id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_asset == null) return const Scaffold(body: Center(child: Text('Asset not found')));

    return Scaffold(
      appBar: AppBar(
        title: Text(_asset!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditAssetScreen(asset: _asset)),
            ).then((_) => _loadData()),
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteAsset),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _asset!.status == 'Available' ? _assignAsset : null,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Assign'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _asset!.status == 'Assigned' ? _returnAsset : null,
                    icon: const Icon(Icons.assignment_return),
                    label: const Text('Return'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text('Assignment History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildHistoryList(),
            const SizedBox(height: 32),
            Text('Maintenance History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMaintenanceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceList() {
    if (_maintenanceRecords.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No maintenance records')));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _maintenanceRecords.length,
      itemBuilder: (context, index) {
        final record = _maintenanceRecords[index];
        return ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.secondaryBackground, child: Icon(Icons.build, color: AppColors.primary)),
          title: Text(record.description),
          subtitle: Text(DateFormat('MMM dd, yyyy').format(record.date)),
          trailing: Text('\$${record.cost.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('Serial Number', _asset!.serialNumber),
            const Divider(),
            _buildInfoRow('Condition', _asset!.condition),
            const Divider(),
            _buildInfoRow('Purchase Date', DateFormat('MMM dd, yyyy').format(_asset!.purchaseDate)),
            const Divider(),
            _buildInfoRow('Status', _asset!.status ?? 'N/A', isStatus: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isStatus ? (value == 'Available' ? AppColors.secondary : AppColors.accent) : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('No assignment history')));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final record = _history[index];
        final bool isCurrent = record.returnedAt == null;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isCurrent ? AppColors.accent.withOpacity(0.2) : AppColors.secondaryBackground,
            child: Icon(isCurrent ? Icons.person : Icons.history, color: isCurrent ? AppColors.accent : AppColors.primary),
          ),
          title: Text(record.employeeName ?? 'Unknown Employee'),
          subtitle: Text(
            isCurrent 
              ? 'Assigned on ${DateFormat('MMM dd, yyyy').format(record.assignedAt)}'
              : 'Returned on ${DateFormat('MMM dd, yyyy').format(record.returnedAt!)}',
          ),
          trailing: isCurrent 
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: const Text('Current', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            : null,
        );
      },
    );
  }
}
