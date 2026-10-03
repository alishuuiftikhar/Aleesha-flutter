import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/delivery.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_and_filter.dart';
import '../widgets/status_badge.dart';
import 'delivery_form_screen.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Delivery> _deliveries = [];
  bool _isLoading = true;
  String _timeframe = 'All';
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadDeliveries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDeliveries() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllDeliveries(
      searchQuery: _searchController.text.trim(),
      filterStatus: _statusFilter,
      timeframe: _timeframe,
    );
    if (mounted) {
      setState(() {
        _deliveries = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Delivery delivery) async {
    await DatabaseHelper.instance.toggleDeliveryFavorite(delivery);
    _loadDeliveries();
  }

  Future<void> _updateStatus(int id, String newStatus) async {
    await DatabaseHelper.instance.updateDeliveryStatus(id, newStatus);
    _loadDeliveries();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Package status updated to $newStatus'), backgroundColor: AppTheme.success),
      );
    }
  }

  Future<void> _deleteDelivery(Delivery delivery) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Delete Delivery',
      content: 'Are you sure you want to delete delivery record "${delivery.deliveryCompany}"?',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteDelivery(delivery.id!);
      _loadDeliveries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delivery record deleted'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  void _showDetailSheet(Delivery delivery) {
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mark_unread_chat_space_outlined, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.deliveryCompany,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      Text(
                        delivery.trackingNumber.isNotEmpty ? 'Tracking: ${delivery.trackingNumber}' : 'No tracking info',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: delivery.status),
              ],
            ),
            const Divider(height: 24),
            if (delivery.packageDescription.isNotEmpty)
              _buildDetailItem(Icons.inventory_2_outlined, 'Description', delivery.packageDescription),
            _buildDetailItem(Icons.calendar_month, 'Expected/Arrival Date', '${delivery.arrivalDate} at ${delivery.arrivalTime}'),
            if (delivery.deliveryPersonName.isNotEmpty)
              _buildDetailItem(Icons.person, 'Courier Person', '${delivery.deliveryPersonName} ${delivery.deliveryPersonPhone.isNotEmpty ? "(${delivery.deliveryPersonPhone})" : ""}'),
            if (delivery.notes.isNotEmpty)
              _buildDetailItem(Icons.note_alt_outlined, 'Notes', delivery.notes),

            const SizedBox(height: 18),

            // Quick status transitions
            if (delivery.status == 'Expected')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _updateStatus(delivery.id!, 'Received');
                  },
                  icon: const Icon(Icons.input_rounded),
                  label: const Text('Mark Received at Gate / Lobby'),
                ),
              ),
            if (delivery.status == 'Received' || delivery.status == 'Expected') ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _updateStatus(delivery.id!, 'Collected');
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Mark Collected by Resident'),
                ),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => DeliveryFormScreen(delivery: delivery)),
                      );
                      if (res == true) _loadDeliveries();
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
                      _deleteDelivery(delivery);
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
        title: const Text('Deliveries & Packages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDeliveries,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.secondaryBackground.withOpacity(0.4),
            padding: const EdgeInsets.all(12),
            child: SearchAndFilterWidget(
              searchController: _searchController,
              onSearchChanged: (val) => _loadDeliveries(),
              selectedTimeframe: _timeframe,
              onTimeframeChanged: (tf) {
                setState(() => _timeframe = tf);
                _loadDeliveries();
              },
              selectedStatus: _statusFilter,
              onStatusChanged: (st) {
                setState(() => _statusFilter = st);
                _loadDeliveries();
              },
              statuses: const ['All', 'Expected', 'Received', 'Collected', 'Returned'],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _deliveries.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.inventory_2_outlined,
                        title: 'No Deliveries Found',
                        description: 'No package delivery records match your criteria.',
                        actionLabel: 'Add Delivery',
                        onActionPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const DeliveryFormScreen()),
                          );
                          if (res == true) _loadDeliveries();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDeliveries,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          itemCount: _deliveries.length,
                          itemBuilder: (context, index) {
                            final item = _deliveries[index];
                            return CustomCard(
                              onTap: () => _showDetailSheet(item),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.local_shipping_outlined, color: AppTheme.primary, size: 24),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.deliveryCompany,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item.packageDescription.isNotEmpty ? item.packageDescription : 'Package Item',
                                              style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
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
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today, size: 12, color: AppTheme.textMuted),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.arrivalDate} (${item.arrivalTime})',
                                            style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                          ),
                                        ],
                                      ),
                                      StatusBadge(status: item.status),
                                    ],
                                  ),
                                  if (item.status == 'Received' || item.status == 'Expected') ...[
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 36,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.success,
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () => _updateStatus(item.id!, 'Collected'),
                                        icon: const Icon(Icons.check, size: 16),
                                        label: const Text('Mark Collected', style: TextStyle(fontSize: 13)),
                                      ),
                                    ),
                                  ],
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
            MaterialPageRoute(builder: (_) => const DeliveryFormScreen()),
          );
          if (res == true) _loadDeliveries();
        },
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Add Delivery'),
      ),
    );
  }
}
