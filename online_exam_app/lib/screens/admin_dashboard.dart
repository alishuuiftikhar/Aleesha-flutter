import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';
import 'create_exam_screen.dart';
import 'manage_questions_screen.dart';
import 'admin_results_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).fetchExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Manage Exams', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.analytics),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminResultsScreen())),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateExamScreen()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<AppProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) return const Center(child: CircularProgressIndicator());
              if (provider.exams.isEmpty) return const Center(child: Text('No exams created yet.'));

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provider.exams.length,
                itemBuilder: (context, index) {
                  final exam = provider.exams[index];
                  return Card(
                    child: ListTile(
                      title: Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${exam.category} • ${exam.isPublished == 1 ? "Published" : "Draft"}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageQuestionsScreen(exam: exam)),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => provider.deleteExam(exam.id!),
                          ),
                          Switch(
                            value: exam.isPublished == 1,
                            onChanged: (val) {
                              provider.updateExam(Exam(
                                id: exam.id,
                                title: exam.title,
                                description: exam.description,
                                category: exam.category,
                                durationMinutes: exam.durationMinutes,
                                totalMarks: exam.totalMarks,
                                creatorId: exam.creatorId,
                                isPublished: val ? 1 : 0,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
