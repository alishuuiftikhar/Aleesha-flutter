import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/team_provider.dart';
import '../../providers/evaluation_provider.dart';
import '../../widgets/common/empty_state.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final team = context.read<TeamProvider>().myTeam;
      if (team != null) context.read<EvaluationProvider>().load(team.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluations = context.watch<EvaluationProvider>().evaluations;
    final isLoading = context.watch<EvaluationProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Evaluations')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : evaluations.isEmpty
              ? const EmptyState(
                  icon: Icons.grading_outlined,
                  title: 'No evaluations yet',
                  message: 'Rubric-based evaluations will appear here once graded.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: evaluations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final e = evaluations[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text('${e.evaluationType} Evaluation',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Text('${e.totalScore}/${e.maxTotalScore}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('By ${e.evaluatorName}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                            const SizedBox(height: 10),
                            ...e.rubric.map((r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(r.criterion, style: const TextStyle(fontSize: 13))),
                                      Text('${r.score}/${r.maxScore}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                )),
                            const Divider(height: 18),
                            const Text('Remarks', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                            const SizedBox(height: 4),
                            Text(e.remarks, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
