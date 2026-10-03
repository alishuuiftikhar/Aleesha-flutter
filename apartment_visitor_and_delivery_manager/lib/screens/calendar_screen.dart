import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/visitor.dart';
import '../models/delivery.dart';
import '../models/maintenance.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/status_badge.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  List<Visitor> _dayVisitors = [];
  List<Delivery> _dayDeliveries = [];
  List<MaintenanceVisit> _dayMaintenance = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDateRecords(_selectedDate);
  }

  Future<void> _loadDateRecords(DateTime date) async {
    setState(() => _isLoading = true);
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    final data = await DatabaseHelper.instance.getRecordsForDate(dateStr);

    if (mounted) {
      setState(() {
        _selectedDate = date;
        _dayVisitors = List<Visitor>.from(data['visitors'] ?? []);
        _dayDeliveries = List<Delivery>.from(data['deliveries'] ?? []);
        _dayMaintenance = List<MaintenanceVisit>.from(data['maintenance'] ?? []);
        _isLoading = false;
      });
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday; // 1 = Mon, 7 = Sun
    final leadingEmpty = firstWeekday - 1;

    final selectedStr = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Calendar'),
      ),
      body: Column(
        children: [
          // Month navigation bar
          Container(
            color: AppTheme.secondaryBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, color: AppTheme.primary, size: 28),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedMonth),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded, color: AppTheme.primary, size: 28),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),

          // Calendar Grid Container
          Container(
            color: AppTheme.cardBackground,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Weekday Headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Calendar Grid Builder
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: leadingEmpty + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < leadingEmpty) {
                      return const SizedBox.shrink();
                    }
                    final dayNum = index - leadingEmpty + 1;
                    final cellDate = DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
                    final isToday = DateFormat('yyyy-MM-dd').format(cellDate) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final isSelected = DateFormat('yyyy-MM-dd').format(cellDate) ==
                        DateFormat('yyyy-MM-dd').format(_selectedDate);

                    return InkWell(
                      onTap: () => _loadDateRecords(cellDate),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary
                              : isToday
                                  ? AppTheme.secondaryBackground
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isToday && !isSelected
                              ? Border.all(color: AppTheme.accent, width: 1.5)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$dayNum',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Selected Date Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppTheme.secondaryBackground.withOpacity(0.5),
            child: Row(
              children: [
                const Icon(Icons.event_available, color: AppTheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedStr,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
              ],
            ),
          ),

          // Day Records List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : (_dayVisitors.isEmpty && _dayDeliveries.isEmpty && _dayMaintenance.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_busy, size: 48, color: AppTheme.textMuted),
                            const SizedBox(height: 8),
                            Text(
                              'No entries scheduled for $selectedStr',
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(14),
                        children: [
                          if (_dayVisitors.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 4),
                              child: Text('Visitors', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                            ),
                            ..._dayVisitors.map((v) => CustomCard(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: AppTheme.primary,
                                      child: Text(v.name.isNotEmpty ? v.name[0].toUpperCase() : 'V', style: const TextStyle(color: Colors.white)),
                                    ),
                                    title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('${v.purpose} • ${v.expectedArrivalTime} - ${v.expectedDepartureTime}'),
                                    trailing: StatusBadge(status: v.status),
                                  ),
                                )),
                          ],

                          if (_dayDeliveries.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: Text('Deliveries', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                            ),
                            ..._dayDeliveries.map((d) => CustomCard(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.local_shipping, color: AppTheme.primary),
                                    ),
                                    title: Text(d.deliveryCompany, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('${d.packageDescription.isNotEmpty ? d.packageDescription : "Package"} • ${d.arrivalTime}'),
                                    trailing: StatusBadge(status: d.status),
                                  ),
                                )),
                          ],

                          if (_dayMaintenance.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: Text('Maintenance Visits', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                            ),
                            ..._dayMaintenance.map((m) => CustomCard(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: AppTheme.highlight.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                      child: const Icon(Icons.handyman, color: AppTheme.highlight),
                                    ),
                                    title: Text(m.workerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('${m.serviceType} • ${m.time}'),
                                    trailing: StatusBadge(status: m.status),
                                  ),
                                )),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
