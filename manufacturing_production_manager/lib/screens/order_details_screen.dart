import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/supabase_service.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String _currentStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status'];
  }

  void _updateStatus(String status) async {
    if (status == 'Completed') {
      final canComplete = await _checkMaterialsAvailability();
      if (!canComplete) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient materials to complete this production!'), backgroundColor: AppConstants.errorColor),
          );
        }
        return;
      }
    }

    setState(() => _isUpdating = true);
    try {
      await Provider.of<SupabaseService>(context, listen: false).updateProductionStatus(widget.order['id'].toString(), status);
      setState(() => _currentStatus = status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status updated to $status')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppConstants.errorColor));
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<bool> _checkMaterialsAvailability() async {
    final supabase = Provider.of<SupabaseService>(context, listen: false);
    // This is a simplified check. In a real app, you'd query the product_materials table.
    // For now, we'll assume the service handles the logic and returns true/false or we do a quick check.
    // To keep it fully functional as requested, I'll add a check method to SupabaseService.
    return await supabase.checkMaterialsAvailability(widget.order['product_id'], widget.order['quantity']);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.order['products'];
    final createdAt = DateTime.parse(widget.order['created_at']);

    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${widget.order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        _buildStatusBadge(_currentStatus),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildInfoRow('Product', product['name']),
                    _buildInfoRow('Quantity', widget.order['quantity'].toString()),
                    _buildInfoRow('Date Created', DateFormat('MMM dd, yyyy HH:mm').format(createdAt)),
                    _buildInfoRow('Notes', widget.order['notes'] ?? 'None'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Update Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.productionStatuses.map((status) {
                final isCurrent = _currentStatus == status;
                return ChoiceChip(
                  label: Text(status),
                  selected: isCurrent,
                  onSelected: (selected) {
                    if (selected && !isCurrent) {
                      _updateStatus(status);
                    }
                  },
                  selectedColor: AppConstants.primaryColor,
                  labelStyle: TextStyle(color: isCurrent ? Colors.white : AppConstants.textColor),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Production Timeline', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTimelineItem('Order Created', DateFormat('MMM dd, yyyy HH:mm').format(createdAt), true),
            _buildTimelineItem('Status changed to $_currentStatus', 'Just now', false),
            if (_isUpdating) const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == 'Completed') color = AppConstants.successColor;
    if (status == 'In Production') color = AppConstants.highlightColor;
    if (status == 'Cancelled') color = AppConstants.errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool isLast) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(color: AppConstants.accentColor, shape: BoxShape.circle),
            ),
            if (!isLast) Container(width: 2, height: 40, color: AppConstants.accentColor.withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
