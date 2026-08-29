import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../theme.dart';

class HabitFormScreen extends StatefulWidget {
  final Habit? habit;
  const HabitFormScreen({super.key, this.habit});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _category;
  late Frequency _frequency;
  TimeOfDay? _reminderTime;
  late int _selectedColorIndex;

  final List<String> _categories = ['Health', 'Fitness', 'Mind', 'Productivity', 'Social', 'Other'];

  @override
  void initState() {
    super.initState();
    _title = widget.habit?.title ?? '';
    _category = widget.habit?.category ?? 'Health';
    _frequency = widget.habit?.frequency ?? Frequency.daily;
    _reminderTime = widget.habit?.reminderTime;
    _selectedColorIndex = widget.habit != null 
        ? AppColors.habitColors.indexWhere((c) => c.value == widget.habit!.colorValue) 
        : 0;
    if (_selectedColorIndex == -1) _selectedColorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'New Habit' : 'Edit Habit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Habit Title',
                  hintText: 'e.g. Morning Meditation',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
                onSaved: (val) => _title = val!,
              ),
              const SizedBox(height: 25),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _category,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 25),
              const Text('Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppColors.habitColors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.habitColors[index],
                          shape: BoxShape.circle,
                          border: _selectedColorIndex == index 
                              ? Border.all(color: AppColors.text, width: 2) 
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Row(
                children: [
                  Radio<Frequency>(
                    value: Frequency.daily,
                    groupValue: _frequency,
                    onChanged: (val) => setState(() => _frequency = val!),
                  ),
                  const Text('Daily'),
                  Radio<Frequency>(
                    value: Frequency.weekly,
                    groupValue: _frequency,
                    onChanged: (val) => setState(() => _frequency = val!),
                  ),
                  const Text('Weekly'),
                ],
              ),
              const SizedBox(height: 25),
              ListTile(
                title: const Text('Reminder Time'),
                subtitle: Text(_reminderTime?.format(context) ?? 'No reminder set'),
                trailing: const Icon(Icons.access_time),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _reminderTime ?? TimeOfDay.now(),
                  );
                  if (time != null) setState(() => _reminderTime = time);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(widget.habit == null ? 'Create Habit' : 'Update Habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<HabitProvider>(context, listen: false);
      
      if (widget.habit == null) {
        provider.addHabit(
          _title,
          _category,
          _frequency,
          _reminderTime,
          AppColors.habitColors[_selectedColorIndex].value,
        );
      } else {
        provider.updateHabit(
          widget.habit!.copyWith(
            title: _title,
            category: _category,
            frequency: _frequency,
            reminderTime: _reminderTime,
            colorValue: AppColors.habitColors[_selectedColorIndex].value,
          ),
        );
      }
      Navigator.pop(context);
    }
  }
}
