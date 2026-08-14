import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataProvider>();
    final pending = data.pendingStudents;
    final approved = data.approvedStudents;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Student Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Students
            pending.isEmpty
                ? const Center(child: Text('No pending approvals.'))
                : ListView.builder(
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final student = pending[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                          title: Text(student.fullName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${student.course} | ID: ${student.studentId}'),
                              if (student.addedByName != null)
                                Text('Added by: ${student.addedByName}', 
                                     style: const TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                onPressed: () => data.approveStudent(student.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => data.rejectStudent(student.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            // Approved Students
            approved.isEmpty
                ? const Center(child: Text('No approved students yet.'))
                : ListView.builder(
                    itemCount: approved.length,
                    itemBuilder: (context, index) {
                      final student = approved[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(student.fullName),
                          subtitle: Text('${student.course} | ID: ${student.studentId}'),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'APPROVED',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
