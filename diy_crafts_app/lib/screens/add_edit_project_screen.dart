import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/craft_project.dart';
import '../providers/project_provider.dart';
import '../theme/app_theme.dart';

class AddEditProjectScreen extends StatefulWidget {
  final CraftProject? project;

  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _category;
  late String _difficulty;
  late String _estimatedTime;
  late String _description;
  late String _imageUrl;
  List<String> _materials = [];
  List<String> _instructions = [];

  final List<String> _categories = ['Paper crafts', 'Decoration', 'Painting', 'Handmade gifts', 'Other'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    if (widget.project != null) {
      _title = widget.project!.title;
      _category = widget.project!.category;
      _difficulty = widget.project!.difficulty;
      _estimatedTime = widget.project!.estimatedTime;
      _description = widget.project!.description;
      _imageUrl = widget.project!.imageUrl;
      _materials = List.from(widget.project!.materials);
      _instructions = List.from(widget.project!.instructions);
    } else {
      _title = '';
      _category = _categories[0];
      _difficulty = _difficulties[0];
      _estimatedTime = '';
      _description = '';
      _imageUrl = 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?q=80&w=1000&auto=format&fit=crop';
      _materials = [];
      _instructions = [];
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final project = CraftProject(
        id: widget.project?.id ?? const Uuid().v4(),
        title: _title,
        category: _category,
        difficulty: _difficulty,
        estimatedTime: _estimatedTime,
        description: _description,
        imageUrl: _imageUrl,
        materials: _materials.isEmpty ? ['Basic tools'] : _materials,
        instructions: _instructions.isEmpty ? ['Start creating!'] : _instructions,
        isUserCreated: true,
        isFavorite: widget.project?.isFavorite ?? false,
        isCompleted: widget.project?.isCompleted ?? false,
        notes: widget.project?.notes ?? '',
        progress: widget.project?.progress ?? 0.0,
      );

      if (widget.project == null) {
        context.read<ProjectProvider>().addProject(project);
      } else {
        context.read<ProjectProvider>().updateProject(project);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Create Project' : 'Edit Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: 'Project Title'),
              validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
              onSaved: (val) => _title = val!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _difficulty,
              decoration: const InputDecoration(labelText: 'Difficulty'),
              items: _difficulties.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (val) => setState(() => _difficulty = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _estimatedTime,
              decoration: const InputDecoration(labelText: 'Estimated Time (e.g., 30 mins)'),
              onSaved: (val) => _estimatedTime = val!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (val) => _description = val!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
              onSaved: (val) => _imageUrl = val!,
            ),
            const SizedBox(height: 24),
            _buildListSection('Materials', _materials, (val) => setState(() => _materials.add(val))),
            const SizedBox(height: 24),
            _buildListSection('Instructions', _instructions, (val) => setState(() => _instructions.add(val))),
            const SizedBox(height: 40),
            if (widget.project != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  context.read<ProjectProvider>().deleteProject(widget.project!.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete Project', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(String title, List<String> list, Function(String) onAdd) {
    final controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...list.asMap().entries.map((entry) => ListTile(
          title: Text(entry.value),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => setState(() => list.removeAt(entry.key)),
          ),
        )),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Add new $title item'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.accent),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onAdd(controller.text);
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
