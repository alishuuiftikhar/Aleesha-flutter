import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../services/database_service.dart';
import '../../models/progress.dart';
import 'bmi_calculator_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final DatabaseService _dbService = DatabaseService();
  late Future<List<Progress>> _progressFuture;

  @override
  void initState() {
    super.initState();
    _refreshProgress();
  }

  void _refreshProgress() {
    setState(() {
      _progressFuture = _dbService.getProgress();
    });
  }

  Future<void> _showAddWeightDialog() async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('LOG WEIGHT', style: GoogleFonts.bebasNeue(letterSpacing: 1.2)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Weight (kg)',
            prefixIcon: Icon(Icons.monitor_weight_outlined),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(controller.text);
              if (weight != null) {
                try {
                  final newProgress = Progress(
                    id: '',
                    userId: '',
                    date: DateTime.now(),
                    weight: weight,
                  );
                  await _dbService.addProgress(newProgress);
                  if (mounted) {
                    Navigator.pop(context);
                    _refreshProgress();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Weight logged successfully!'), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Database Error: ${e.toString()}'), backgroundColor: AppColors.error),
                    );
                  }
                }
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY PROGRESS', style: GoogleFonts.bebasNeue(letterSpacing: 1.5)),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshProgress(),
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildModernChartPlaceholder(),
              const SizedBox(height: 25),
              _buildBmiButton(),
              const SizedBox(height: 35),
              Text(
                'LOG HISTORY',
                style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 1.2, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Progress>>(
                future: _progressFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }
                  final history = snapshot.data ?? [];
                  if (history.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      String change = '';
                      bool isDown = false;
                      if (index < history.length - 1) {
                        final diff = item.weight - history[index + 1].weight;
                        change = '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg';
                        isDown = diff < 0;
                      }
                      return _buildProfessionalHistoryItem(item, change, isDown);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWeightDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('LOG WEIGHT', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildModernChartPlaceholder() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_graph_rounded, size: 50, color: AppColors.primary),
            const SizedBox(height: 12),
            Text('WEIGHT TRENDS', style: GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 1.2)),
            Text('Coming soon in next update', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.secondaryText)),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiButton() {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BmiCalculatorScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'BMI CALCULATOR',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHistoryItem(Progress item, String change, bool isDown) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.date.day}/${item.date.month}/${item.date.year}',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text('Recorded at ${item.date.hour}:${item.date.minute}', style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.weight} kg', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
              if (change.isNotEmpty)
                Text(
                  change,
                  style: GoogleFonts.poppins(
                    color: isDown ? Colors.green : AppColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: 12),
          Text(
            'DATABASE ERROR',
            style: GoogleFonts.bebasNeue(color: AppColors.error, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Table not found. Please run the SQL script provided in your Supabase dashboard.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.inbox_rounded, size: 60, color: AppColors.divider),
        const SizedBox(height: 15),
        Text('NO RECORDS YET', style: GoogleFonts.bebasNeue(fontSize: 18, color: AppColors.secondaryText)),
      ],
    );
  }
}
