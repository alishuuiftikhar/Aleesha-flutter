import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../theme.dart';
import '../../widgets/habit_card.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'History',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
                ),
                const Spacer(),
                const Icon(Icons.history, color: AppColors.primary),
              ],
            ),
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            ),
            eventLoader: (day) {
              return habitProvider.habits.where((h) => 
                h.completedDays.any((d) => isSameDay(d, day))
              ).toList();
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Habits on ${_selectedDay != null ? _selectedDay!.toString().split(' ')[0] : 'Selected Day'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 15),
                ...habitProvider.habits.map((habit) {
                  final isDone = habit.completedDays.any((d) => isSameDay(d, _selectedDay));
                  return _buildHistoryItem(habit, isDone);
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(dynamic habit, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondaryBackground.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, 
               color: isDone ? AppColors.primary : Colors.grey),
          const SizedBox(width: 15),
          Text(habit.title, style: TextStyle(
            fontSize: 16, 
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? AppColors.text.withOpacity(0.5) : AppColors.text,
          )),
        ],
      ),
    );
  }
}
