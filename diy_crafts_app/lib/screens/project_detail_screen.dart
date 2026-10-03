import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/craft_project.dart';
import '../providers/project_provider.dart';
import '../theme/app_theme.dart';

class ProjectDetailScreen extends StatefulWidget {
  final CraftProject project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.project.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 32),
                  _buildProgressSection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Materials Needed'),
                  _buildMaterialsList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Step-by-Step Instructions'),
                  _buildInstructionsList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('My Notes'),
                  _buildNotesSection(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final newStatus = !widget.project.isCompleted;
          context.read<ProjectProvider>().updateProjectStatus(
            widget.project.id, 
            isCompleted: newStatus,
            progress: newStatus ? 1.0 : widget.project.progress
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(newStatus ? 'Project marked as completed!' : 'Project marked as ongoing')),
          );
        },
        label: Text(widget.project.isCompleted ? 'Mark as Ongoing' : 'Mark as Completed'),
        icon: Icon(widget.project.isCompleted ? Icons.undo : Icons.check),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'project-img-${widget.project.id}',
          child: Image.network(
            widget.project.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            widget.project.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primary,
          ),
          onPressed: () {
            context.read<ProjectProvider>().toggleFavorite(widget.project.id);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.project.category,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(widget.project.difficulty, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.project.title,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: AppColors.secondary),
            const SizedBox(width: 4),
            Text(widget.project.estimatedTime),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.project.description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Project Progress', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${(widget.project.progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: widget.project.progress,
          onChanged: (value) {
            context.read<ProjectProvider>().updateProjectStatus(widget.project.id, progress: value);
            setState(() {});
          },
          activeColor: AppColors.accent,
          inactiveColor: AppColors.secondaryBackground,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildMaterialsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.project.materials.map((material) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.secondaryBackground),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(material),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstructionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.project.instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.secondary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.project.instructions[index],
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotesSection() {
    return TextField(
      controller: _notesController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Add your own tips or notes here...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondaryBackground),
        ),
      ),
      onChanged: (value) {
        context.read<ProjectProvider>().updateProjectStatus(widget.project.id, notes: value);
      },
    );
  }
}
