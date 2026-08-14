import 'package:flutter/material.dart';

void main() => runApp(const PulseFitnessApp());

class PulseFitnessApp extends StatelessWidget {
  const PulseFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Fitness & Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF070B14),
        fontFamily: 'Roboto',
      ),
      home: const FitnessHomeScreen(),
    );
  }
}

class FitnessHomeScreen extends StatefulWidget {
  const FitnessHomeScreen({super.key});

  @override
  State<FitnessHomeScreen> createState() => _FitnessHomeScreenState();
}

class _FitnessHomeScreenState extends State<FitnessHomeScreen> {
  int _currentIndex = 0;
  int _activeWorkoutIndex = -1;

  final List<Map<String, dynamic>> _workouts = [
    {
      'title': 'High Intensity HIIT',
      'category': 'Cardio & Fat Burn',
      'duration': '35 mins',
      'calories': '420 kcal',
      'level': 'Advanced',
      'icon': Icons.local_fire_department_rounded,
      'color': const Color(0xFFF97316),
    },
    {
      'title': 'Core Strength Builder',
      'category': 'Abs & Lower Back',
      'duration': '25 mins',
      'calories': '280 kcal',
      'level': 'Intermediate',
      'icon': Icons.fitness_center_rounded,
      'color': const Color(0xFF3B82F6),
    },
    {
      'title': 'Vinyasa Flow Yoga',
      'category': 'Flexibility & Mind',
      'duration': '45 mins',
      'calories': '180 kcal',
      'level': 'Beginner',
      'icon': Icons.self_improvement_rounded,
      'color': const Color(0xFFA855F7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF10B981), width: 2),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF10B981).withOpacity(0.35), blurRadius: 12, spreadRadius: 1),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFF131D31),
                          child: Icon(Icons.person_rounded, color: Color(0xFF10B981), size: 28),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back,', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                          SizedBox(height: 2),
                          Text('Alex Morgan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131D31),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, color: Colors.white70, size: 22),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // Daily Goal Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF047857), Color(0xFF10B981), Color(0xFF34D399)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Goal Summary', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('🔥 85% Completed', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _MetricColumn(label: 'Calories', value: '1,840', unit: 'kcal'),
                        _MetricColumn(label: 'Active Time', value: '68', unit: 'mins'),
                        _MetricColumn(label: 'Water Intake', value: '2.4', unit: 'L'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.85,
                        backgroundColor: Colors.black26,
                        color: Colors.white,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Activity Categories
              const Text('Activity Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryChip(icon: Icons.directions_run_rounded, label: 'Running', isSelected: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
                  _CategoryChip(icon: Icons.fitness_center_rounded, label: 'Strength', isSelected: _currentIndex == 1, onTap: () => setState(() => _currentIndex = 1)),
                  _CategoryChip(icon: Icons.self_improvement_rounded, label: 'Yoga', isSelected: _currentIndex == 2, onTap: () => setState(() => _currentIndex = 2)),
                  _CategoryChip(icon: Icons.local_dining_rounded, label: 'Nutrition', isSelected: _currentIndex == 3, onTap: () => setState(() => _currentIndex = 3)),
                ],
              ),
              const SizedBox(height: 28),

              // Featured Workouts List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featured Workouts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3)),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    onPressed: () {},
                    child: const Text('View All', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._workouts.asMap().entries.map((entry) {
                int index = entry.key;
                Map workout = entry.value;
                bool isRunning = _activeWorkoutIndex == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isRunning ? const Color(0xFF132A32) : const Color(0xFF131D31),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isRunning ? const Color(0xFF10B981) : Colors.white.withOpacity(0.06),
                      width: isRunning ? 1.5 : 1,
                    ),
                    boxShadow: [
                      if (isRunning)
                        BoxShadow(color: const Color(0xFF10B981).withOpacity(0.15), blurRadius: 12, spreadRadius: 1),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: workout['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(workout['icon'], color: workout['color'], size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(workout['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 3),
                            Text(workout['category'], style: const TextStyle(fontSize: 11, color: Colors.white54)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 13, color: Color(0xFF10B981)),
                                const SizedBox(width: 3),
                                Text(workout['duration'], style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500)),
                                const SizedBox(width: 12),
                                const Icon(Icons.local_fire_department_outlined, size: 13, color: Color(0xFFF97316)),
                                const SizedBox(width: 3),
                                Text(workout['calories'], style: const TextStyle(fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isRunning ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                          color: const Color(0xFF10B981),
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _activeWorkoutIndex = isRunning ? -1 : index;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isRunning ? 'Workout Paused' : 'Starting ${workout['title']} session...'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF131D31),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF070B14),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.home_rounded, color: Color(0xFF10B981), size: 28),
            Icon(Icons.bar_chart_rounded, color: Colors.white38, size: 28),
            Icon(Icons.restaurant_menu_rounded, color: Colors.white38, size: 28),
            Icon(Icons.person_outline_rounded, color: Colors.white38, size: 28),
          ],
        ),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MetricColumn({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
        const SizedBox(height: 3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(width: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF131D31),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.05),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 22),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}