import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../models/models.dart';
import 'scene_detail_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final project = provider.projects.firstWhere((p) => p.id == projectId);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    project.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                    ),
                  ),
                  background: Container(
                    color: AppColors.primary.withValues(alpha: 0.8),
                    child: Center(
                      child: Icon(
                        Icons.movie_outlined,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _showEditProjectDialog(context, project),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _confirmDelete(context, provider),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(project),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'SCENES',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: AppColors.text,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showAddSceneDialog(context),
                            icon: const Icon(Icons.add, color: AppColors.accent),
                            label: const Text('ADD SCENE', style: TextStyle(color: AppColors.accent)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final scene = project.scenes[index];
                    return _SceneTile(projectId: project.id, scene: scene);
                  },
                  childCount: project.scenes.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(Project project) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Production Notes',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            project.productionNotes.isEmpty ? 'No production notes yet.' : project.productionNotes,
            style: TextStyle(color: AppColors.text.withValues(alpha: 0.8)),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Scenes', project.scenes.length.toString()),
              _buildStat('Shots', project.totalShots.toString()),
              _buildStat('Progress', '${(project.progress * 100).toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.secondary),
        ),
      ],
    );
  }

  void _showEditProjectDialog(BuildContext context, Project project) {
    final nameController = TextEditingController(text: project.name);
    final descController = TextEditingController(text: project.description);
    final notesController = TextEditingController(text: project.productionNotes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Edit Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Production Notes'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              project.name = nameController.text;
              project.description = descController.text;
              project.productionNotes = notesController.text;
              Provider.of<AppProvider>(context, listen: false).updateProject(project);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('SAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('This will permanently remove all scenes and shots.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              provider.deleteProject(projectId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddSceneDialog(BuildContext context) {
    final titleController = TextEditingController();
    final locController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Scene'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Scene Title')),
            TextField(controller: locController, decoration: const InputDecoration(labelText: 'Location')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false)
                    .addScene(projectId, titleController.text, locController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }
}

class _SceneTile extends StatelessWidget {
  final String projectId;
  final Scene scene;

  const _SceneTile({required this.projectId, required this.scene});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryBackground),
      ),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SceneDetailScreen(projectId: projectId, sceneId: scene.id)),
        ),
        title: Text(
          scene.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.text),
        ),
        subtitle: Text('${scene.location} • ${scene.shots.length} shots'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(scene.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            scene.status.name.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(scene.status),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(SceneStatus status) {
    switch (status) {
      case SceneStatus.planned: return AppColors.secondary;
      case SceneStatus.inProgress: return AppColors.accent;
      case SceneStatus.completed: return Colors.green;
      case SceneStatus.cancelled: return Colors.red;
    }
  }
}
