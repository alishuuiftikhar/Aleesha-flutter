import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import 'project_details_screen.dart';
import 'package:intl/intl.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProjectDialog(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                hintStyle: const TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final filteredProjects = provider.projects
              .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          if (filteredProjects.isEmpty) {
            return const Center(child: Text('No projects found.'));
          }
          return ListView.builder(
            itemCount: filteredProjects.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              return FutureBuilder<double>(
                future: provider.getProjectProgress(project.id!),
                builder: (context, snapshot) {
                  final progress = snapshot.data ?? 0.0;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        project.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(project.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(DateFormat.yMMMd().format(project.deadline), style: const TextStyle(fontSize: 12)),
                              const Spacer(),
                              Text('\$${project.budget}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsScreen(project: project),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final budgetController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    int? selectedClientId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Project'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Project Name')),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: budgetController, decoration: const InputDecoration(labelText: 'Budget'), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                Consumer<AppProvider>(
                  builder: (context, provider, _) => DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Client'),
                    items: provider.clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                    onChanged: (val) => selectedClientId = val,
                  ),
                ),
                ListTile(
                  title: Text('Deadline: ${DateFormat.yMMMd().format(selectedDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && selectedClientId != null) {
                  Provider.of<AppProvider>(context, listen: false).addProject(Project(
                    name: nameController.text,
                    description: descController.text,
                    clientId: selectedClientId!,
                    deadline: selectedDate,
                    budget: double.tryParse(budgetController.text) ?? 0.0,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
