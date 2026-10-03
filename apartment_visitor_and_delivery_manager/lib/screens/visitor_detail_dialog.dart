import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/visitor.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/status_badge.dart';
import 'visitor_form_screen.dart';

class VisitorDetailSheet extends StatefulWidget {
  final Visitor visitor;
  final VoidCallback onDataChanged;

  const VisitorDetailSheet({
    super.key,
    required this.visitor,
    required this.onDataChanged,
  });

  static void show(BuildContext context, Visitor visitor, VoidCallback onDataChanged) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VisitorDetailSheet(visitor: visitor, onDataChanged: onDataChanged),
    );
  }

  @override
  State<VisitorDetailSheet> createState() => _VisitorDetailSheetState();
}

class _VisitorDetailSheetState extends State<VisitorDetailSheet> {
  late Visitor _visitor;

  @override
  void initState() {
    super.initState();
    _visitor = widget.visitor;
  }

  Future<void> _updateStatus(String newStatus) async {
    await DatabaseHelper.instance.updateVisitorStatus(_visitor.id!, newStatus);
    final updated = await DatabaseHelper.instance.getVisitorById(_visitor.id!);
    if (updated != null && mounted) {
      setState(() {
        _visitor = updated;
      });
      widget.onDataChanged();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated to $newStatus'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    await DatabaseHelper.instance.toggleVisitorFavorite(_visitor);
    final updated = await DatabaseHelper.instance.getVisitorById(_visitor.id!);
    if (updated != null && mounted) {
      setState(() {
        _visitor = updated;
      });
      widget.onDataChanged();
    }
  }

  Future<void> _deleteVisitor() async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Delete Visitor',
      content: 'Are you sure you want to delete visitor "${_visitor.name}"?',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteVisitor(_visitor.id!);
      widget.onDataChanged();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor deleted'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  Future<void> _editVisitor() async {
    Navigator.of(context).pop();
    final res = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VisitorFormScreen(visitor: _visitor)),
    );
    if (res == true) {
      widget.onDataChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.mainBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header handle and actions bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.primary,
                child: Text(
                  _visitor.name.isNotEmpty ? _visitor.name[0].toUpperCase() : 'V',
                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _visitor.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _visitor.purpose.isNotEmpty ? _visitor.purpose : 'Visitor',
                      style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _visitor.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: _visitor.isFavorite ? AppTheme.accent : AppTheme.textMuted,
                  size: 28,
                ),
                onPressed: _toggleFavorite,
              ),
              StatusBadge(status: _visitor.status),
            ],
          ),
          const Divider(height: 28),

          // Detail Grid Items
          _buildInfoRow(Icons.calendar_month, 'Visit Date', _visitor.visitDate),
          _buildInfoRow(Icons.access_time, 'Arrival / Departure Time', '${_visitor.expectedArrivalTime} - ${_visitor.expectedDepartureTime}'),
          if (_visitor.phone.isNotEmpty) _buildInfoRow(Icons.phone, 'Phone Number', _visitor.phone),
          if (_visitor.apartment.isNotEmpty) _buildInfoRow(Icons.home, 'Target Apartment', _visitor.apartment),
          _buildInfoRow(Icons.groups, 'Number of People', '${_visitor.numberOfPeople} person(s)'),
          if (_visitor.vehicleNumber.isNotEmpty) _buildInfoRow(Icons.directions_car, 'Vehicle Number', _visitor.vehicleNumber),
          if (_visitor.notes.isNotEmpty) _buildInfoRow(Icons.note, 'Notes', _visitor.notes),

          const SizedBox(height: 20),

          // Quick Action Status Buttons
          if (_visitor.status == 'Expected')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                onPressed: () => _updateStatus('Arrived'),
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Arrived'),
              ),
            ),

          if (_visitor.status == 'Arrived')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondary),
                onPressed: () => _updateStatus('Departed'),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Mark as Departed'),
              ),
            ),

          const SizedBox(height: 10),

          // Edit / Delete Buttons Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _editVisitor,
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
                  onPressed: _deleteVisitor,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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
}
