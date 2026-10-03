import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/entry_history.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';

class EntryHistoryScreen extends StatefulWidget {
  const EntryHistoryScreen({super.key});

  @override
  State<EntryHistoryScreen> createState() => _EntryHistoryScreenState();
}

class _EntryHistoryScreenState extends State<EntryHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EntryHistory> _historyList = [];
  bool _isLoading = true;
  String _selectedType = 'All';

  final List<String> _typeFilters = ['All', 'Visitor', 'Delivery', 'Maintenance'];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllEntryHistory(
      searchQuery: _searchController.text.trim(),
      typeFilter: _selectedType,
    );
    if (mounted) {
      setState(() {
        _historyList = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _clearHistory() async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Clear Entry History',
      content: 'Are you sure you want to clear all entry log records? This action cannot be undone.',
      confirmText: 'Clear All',
    );

    if (confirm == true) {
      await DatabaseHelper.instance.clearEntryHistory();
      _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry history cleared'), backgroundColor: AppTheme.primary),
        );
      }
    }
  }

  IconData _getTypeIcon(String type) {
    if (type.contains('Visitor')) return Icons.nature_people_rounded;
    if (type.contains('Delivery') || type.contains('Package')) return Icons.local_shipping_rounded;
    if (type.contains('Maintenance')) return Icons.handyman_rounded;
    return Icons.history_rounded;
  }

  Color _getTypeColor(String type) {
    if (type.contains('Arrival') || type.contains('Received')) return AppTheme.success;
    if (type.contains('Departure') || type.contains('Collected')) return AppTheme.primary;
    if (type.contains('Maintenance')) return AppTheme.highlight;
    return AppTheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry History Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _historyList.isEmpty ? null : _clearHistory,
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: AppTheme.secondaryBackground.withOpacity(0.4),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => _loadHistory(),
                  decoration: InputDecoration(
                    hintText: 'Search entry logs...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _loadHistory();
                            },
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _typeFilters.map((tf) {
                      final isSelected = _selectedType == tf;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ChoiceChip(
                          label: Text(tf),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedType = tf);
                              _loadHistory();
                            }
                          },
                          selectedColor: AppTheme.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppTheme.textDark,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _historyList.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.history_toggle_off,
                        title: 'No Entry Logs Found',
                        description: 'Entry logs are automatically recorded when visitors arrive/depart or deliveries/maintenance occur.',
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHistory,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          itemCount: _historyList.length,
                          itemBuilder: (context, index) {
                            final log = _historyList[index];
                            final color = _getTypeColor(log.type);
                            return CustomCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(_getTypeIcon(log.type), color: color, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                log.personOrCompany,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textDark,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: color.withOpacity(0.12),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: color, width: 1),
                                              ),
                                              child: Text(
                                                log.type,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: color,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (log.details.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            log.details,
                                            style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_rounded, size: 12, color: AppTheme.textMuted),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${log.date} at ${log.time}',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    );
  }
}
