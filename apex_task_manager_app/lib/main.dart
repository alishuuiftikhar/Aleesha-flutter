import 'package:flutter/material.dart';

void main() => runApp(const ApexTaskManagerApp());

class ApexTaskManagerApp extends StatelessWidget {
  const ApexTaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        fontFamily: 'Roboto',
      ),
      home: const TaskHomeScreen(),
    );
  }
}

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({super.key});

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  String _filter = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Redesign Mobile App UI', 'category': 'Design', 'time': '10:00 AM', 'isCompleted': true, 'color': Colors.purple},
    {'title': 'Backend API Integration', 'category': 'Dev', 'time': '01:30 PM', 'isCompleted': false, 'color': Colors.blue},
    {'title': 'Weekly Sprint Planning', 'category': 'Mgmt', 'time': '04:00 PM', 'isCompleted': false, 'color': Colors.orange},
    {'title': 'Client Progress Report', 'category': 'Business', 'time': '05:30 PM', 'isCompleted': false, 'color': Colors.teal},
  ];

  List<Map<String, dynamic>> get _processedTasks {
    return _tasks.where((task) {
      bool matchesSearch = task['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task['category'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_filter == 'Active') return matchesSearch && !task['isCompleted'];
      if (_filter == 'Completed') return matchesSearch && task['isCompleted'];
      return matchesSearch;
    }).toList();
  }

  void _showAddTaskSheet() {
    final titleController = TextEditingController();
    final catController = TextEditingController();
    Color selectedColor = Colors.purple;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Task Title', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 12),
            TextField(controller: catController, decoration: InputDecoration(labelText: 'Category (e.g. Design)', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    setState(() {
                      _tasks.add({
                        'title': titleController.text,
                        'category': catController.text.isEmpty ? 'General' : catController.text,
                        'time': 'Just Now',
                        'isCompleted': false,
                        'color': selectedColor,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _tasks.where((t) => t['isCompleted']).length;
    double progress = _tasks.isEmpty ? 0 : completedCount / _tasks.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Apex Task Manager', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's Progress", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text('$completedCount of ${_tasks.length} Completed', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white24, color: Colors.white, minHeight: 8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Field
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Chips
          Row(
            children: ['All', 'Active', 'Completed'].map((f) {
              bool isSel = _filter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: isSel,
                  selectedColor: const Color(0xFF7C3AED),
                  labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (s) => setState(() => _filter = f),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          const Text('Scheduled Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),

          // Task List Builder
          _processedTasks.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text('No tasks found!', style: TextStyle(color: Colors.grey))),
          )
              : Column(
            children: _processedTasks.map((task) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: task['isCompleted'],
                      activeColor: task['color'],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onChanged: (val) => setState(() => task['isCompleted'] = val),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              decoration: task['isCompleted'] ? TextDecoration.lineThrough : null,
                              color: task['isCompleted'] ? Colors.grey : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(task['time'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: task['color'].withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(task['category'], style: TextStyle(color: task['color'], fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () => setState(() => _tasks.remove(task)),
                          child: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C3AED),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: _showAddTaskSheet,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}