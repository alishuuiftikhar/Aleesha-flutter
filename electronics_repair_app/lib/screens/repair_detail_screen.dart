import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/repair_provider.dart';
import '../models/repair_order.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';

class RepairDetailScreen extends StatefulWidget {
  final Map<String, dynamic> repair;
  const RepairDetailScreen({super.key, required this.repair});

  @override
  State<RepairDetailScreen> createState() => _RepairDetailScreenState();
}

class _RepairDetailScreenState extends State<RepairDetailScreen> {
  List<Map<String, dynamic>> _parts = [];
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final db = await DatabaseHelper.instance.database;
    final partsData = await db.rawQuery('''
      SELECT rp.*, p.name 
      FROM repair_parts rp
      JOIN parts p ON rp.part_id = p.id
      WHERE rp.repair_order_id = ?
    ''', [widget.repair['id']]);
    
    final notesData = await db.query('repair_notes', where: 'repair_order_id = ?', whereArgs: [widget.repair['id']]);
    
    setState(() {
      _parts = partsData;
      _notes = notesData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final repair = widget.repair;
    double totalPartsCost = _parts.fold(0, (sum, item) => sum + ((item['price_at_time'] as num) * (item['quantity'] as num)));

    return Scaffold(
      appBar: AppBar(title: Text('Repair #${repair['id']}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(repair, totalPartsCost),
          const SizedBox(height: 24),
          _buildSectionHeader('Parts Used', () => _showAddPartDialog(context)),
          ..._parts.map((p) => ListTile(
            title: Text(p['name']),
            subtitle: Text('Qty: ${p['quantity']} x \$${p['price_at_time']}'),
            trailing: Text('\$${(p['quantity'] * p['price_at_time']).toStringAsFixed(2)}'),
          )),
          if (_parts.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('No parts added.')),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Repair Notes', () => _showAddNoteDialog(context)),
          ..._notes.map((n) => ListTile(
            title: Text(n['note']),
            subtitle: Text(n['created_at'].toString().split('T')[0]),
          )),
          if (_notes.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('No notes added.')),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> repair, double partsCost) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${repair['device_type']} - ${repair['device_model']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Customer: ${repair['customer_name']}'),
            Text('Technician: ${repair['technician_name']}'),
            const Divider(),
            Text('Problem: ${repair['problem_description']}'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Labor Cost (Est):'),
                Text('\$${repair['estimated_cost']}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Parts Total:'),
                Text('\$${partsCost.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total cost:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('\$${(repair['estimated_cost'] + partsCost).toStringAsFixed(2)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle, color: AppTheme.accentColor), onPressed: onAdd),
      ],
    );
  }

  void _showAddPartDialog(BuildContext context) async {
    final provider = Provider.of<RepairProvider>(context, listen: false);
    int? selectedPartId;
    final qtyController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Part to Repair'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              items: provider.parts.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
              onChanged: (val) => selectedPartId = val,
              decoration: const InputDecoration(labelText: 'Select Part'),
            ),
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (selectedPartId != null) {
                final part = provider.parts.firstWhere((p) => p.id == selectedPartId);
                await DatabaseHelper.instance.insert('repair_parts', {
                  'repair_order_id': widget.repair['id'],
                  'part_id': selectedPartId,
                  'quantity': int.parse(qtyController.text),
                  'price_at_time': part.price,
                });
                _loadDetails();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Repair Note'),
        content: TextField(controller: noteController, decoration: const InputDecoration(labelText: 'Note'), maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (noteController.text.isNotEmpty) {
                await DatabaseHelper.instance.insert('repair_notes', {
                  'repair_order_id': widget.repair['id'],
                  'note': noteController.text,
                  'created_at': DateTime.now().toIso8601String(),
                });
                _loadDetails();
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
