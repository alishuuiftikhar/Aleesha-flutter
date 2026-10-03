import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/visitor.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_and_filter.dart';
import '../widgets/status_badge.dart';
import 'visitor_detail_dialog.dart';
import 'visitor_form_screen.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Visitor> _visitors = [];
  bool _isLoading = true;
  String _timeframe = 'All';
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadVisitors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVisitors() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getAllVisitors(
      searchQuery: _searchController.text.trim(),
      filterStatus: _statusFilter,
      timeframe: _timeframe,
    );
    if (mounted) {
      setState(() {
        _visitors = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Visitor visitor) async {
    await DatabaseHelper.instance.toggleVisitorFavorite(visitor);
    _loadVisitors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVisitors,
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
              onSearchChanged: (val) => _loadVisitors(),
              selectedTimeframe: _timeframe,
              onTimeframeChanged: (tf) {
                setState(() => _timeframe = tf);
                _loadVisitors();
              },
              selectedStatus: _statusFilter,
              onStatusChanged: (st) {
                setState(() => _statusFilter = st);
                _loadVisitors();
              },
              statuses: const ['All', 'Expected', 'Arrived', 'Departed'],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _visitors.isEmpty
                    ? EmptyStateWidget(
                        icon: Icons.people_outline_rounded,
                        title: 'No Visitors Found',
                        description: _searchController.text.isNotEmpty
                            ? 'No visitor matches your search query'
                            : 'There are no visitor records for the selected filters.',
                        actionLabel: 'Add Visitor',
                        onActionPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
                          );
                          if (res == true) _loadVisitors();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadVisitors,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          itemCount: _visitors.length,
                          itemBuilder: (context, index) {
                            final item = _visitors[index];
                            return CustomCard(
                              onTap: () {
                                VisitorDetailSheet.show(context, item, _loadVisitors);
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primary,
                                    child: Text(
                                      item.name.isNotEmpty ? item.name[0].toUpperCase() : 'V',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
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
                                                item.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textDark,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            StatusBadge(status: item.status),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.purpose.isNotEmpty ? item.purpose : "Visitor"} • ${item.apartment}',
                                          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 12, color: AppTheme.textMuted),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${item.visitDate} (${item.expectedArrivalTime})',
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                            ),
                                          ],
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
            MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
          );
          if (res == true) _loadVisitors();
        },
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Visitor'),
      ),
    );
  }
}
