import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../theme/colors.dart';
import '../models/models.dart';

class SceneDetailScreen extends StatelessWidget {
  final String projectId;
  final String sceneId;

  const SceneDetailScreen({super.key, required this.projectId, required this.sceneId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final project = provider.projects.firstWhere((p) => p.id == projectId);
        final scene = project.scenes.firstWhere((s) => s.id == sceneId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text(scene.title, style: const TextStyle(color: AppColors.text)),
            iconTheme: const IconThemeData(color: AppColors.text),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditSceneDialog(context, provider, scene),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSceneHeader(scene),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SHOT LIST',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                    IconButton(
                      onPressed: () => _showAddShotDialog(context, provider),
                      icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...scene.shots.map((shot) => _ShotCard(
                      projectId: projectId,
                      sceneId: sceneId,
                      shot: shot,
                    )),
                if (scene.shots.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text('No shots planned for this scene.', style: TextStyle(color: AppColors.secondary)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSceneHeader(Scene scene) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(scene.location.isEmpty ? 'TBD' : scene.location, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Notes:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(scene.notes.isEmpty ? 'No notes.' : scene.notes, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              if (scene.characters.isNotEmpty)
                ...scene.characters.map((c) => Chip(label: Text(c, style: const TextStyle(fontSize: 10)), backgroundColor: AppColors.cardBackground)),
              if (scene.props.isNotEmpty)
                ...scene.props.map((p) => Chip(label: Text(p, style: const TextStyle(fontSize: 10)), backgroundColor: AppColors.accent.withValues(alpha: 0.2))),
            ],
          )
        ],
      ),
    );
  }

  void _showEditSceneDialog(BuildContext context, AppProvider provider, Scene scene) {
    final titleController = TextEditingController(text: scene.title);
    final locController = TextEditingController(text: scene.location);
    final notesController = TextEditingController(text: scene.notes);
    final charController = TextEditingController();
    final propController = TextEditingController();
    SceneStatus selectedStatus = scene.status;
    List<String> tempChars = List.from(scene.characters);
    List<String> tempProps = List.from(scene.props);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Scene'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: locController, decoration: const InputDecoration(labelText: 'Location')),
                TextField(controller: notesController, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
                const SizedBox(height: 16),
                DropdownButton<SceneStatus>(
                  value: selectedStatus,
                  isExpanded: true,
                  items: SceneStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                  onChanged: (val) => setState(() => selectedStatus = val!),
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(child: TextField(controller: charController, decoration: const InputDecoration(labelText: 'Add Character'))),
                    IconButton(icon: const Icon(Icons.add), onPressed: () {
                      if (charController.text.isNotEmpty) {
                        setState(() {
                          tempChars.add(charController.text);
                          charController.clear();
                        });
                      }
                    }),
                  ],
                ),
                Wrap(spacing: 4, children: tempChars.map((c) => Chip(label: Text(c), onDeleted: () => setState(() => tempChars.remove(c)))).toList()),
                Row(
                  children: [
                    Expanded(child: TextField(controller: propController, decoration: const InputDecoration(labelText: 'Add Prop'))),
                    IconButton(icon: const Icon(Icons.add), onPressed: () {
                      if (propController.text.isNotEmpty) {
                        setState(() {
                          tempProps.add(propController.text);
                          propController.clear();
                        });
                      }
                    }),
                  ],
                ),
                Wrap(spacing: 4, children: tempProps.map((p) => Chip(label: Text(p), onDeleted: () => setState(() => tempProps.remove(p)))).toList()),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                scene.title = titleController.text;
                scene.location = locController.text;
                scene.notes = notesController.text;
                scene.status = selectedStatus;
                scene.characters = tempChars;
                scene.props = tempProps;
                provider.updateScene(projectId, scene);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Scene?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              provider.deleteScene(projectId, sceneId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddShotDialog(BuildContext context, AppProvider provider) {
    final titleController = TextEditingController();
    ShotType selectedType = ShotType.mediumShot;
    CameraAngle selectedAngle = CameraAngle.eyeLevel;
    CameraMovement selectedMovement = CameraMovement.static;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Shot'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Shot Description (e.g. Hero enters room)')),
                const SizedBox(height: 16),
                _buildDropdown<ShotType>('Type', selectedType, ShotType.values, (val) => setState(() => selectedType = val!)),
                _buildDropdown<CameraAngle>('Angle', selectedAngle, CameraAngle.values, (val) => setState(() => selectedAngle = val!)),
                _buildDropdown<CameraMovement>('Movement', selectedMovement, CameraMovement.values, (val) => setState(() => selectedMovement = val!)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final shot = Shot(
                    id: const Uuid().v4(),
                    title: titleController.text,
                    type: selectedType,
                    angle: selectedAngle,
                    movement: selectedMovement,
                  );
                  provider.addShot(projectId, sceneId, shot);
                  Navigator.pop(context);
                }
              },
              child: const Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDropdown<T extends Enum>(String label, T value, List<T> items, ValueChanged<T?> onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          flex: 3,
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: Container(height: 1, color: AppColors.secondary),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.name, style: const TextStyle(fontSize: 12)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
}

class _ShotCard extends StatelessWidget {
  final String projectId;
  final String sceneId;
  final Shot shot;

  const _ShotCard({required this.projectId, required this.sceneId, required this.shot});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: shot.isCompleted ? Colors.green.withValues(alpha: 0.5) : Colors.transparent),
      ),
      child: ListTile(
        leading: Checkbox(
          value: shot.isCompleted,
          activeColor: Colors.green,
          onChanged: (_) => Provider.of<AppProvider>(context, listen: false)
              .toggleShotCompletion(projectId, sceneId, shot.id),
        ),
        title: Text(
          shot.title,
          style: TextStyle(
            decoration: shot.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${shot.type.name.toUpperCase()} • ${shot.angle.name} • ${shot.movement.name}',
          style: const TextStyle(fontSize: 10),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showShotDetails(context, shot),
        ),
      ),
    );
  }

  void _showShotDetails(BuildContext context, Shot shot) {
    final titleController = TextEditingController(text: shot.title);
    final lensController = TextEditingController(text: shot.lens);
    ShotType selectedType = shot.type;
    CameraAngle selectedAngle = shot.angle;
    CameraMovement selectedMovement = shot.movement;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('EDIT SHOT', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: AppColors.primary)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      Provider.of<AppProvider>(context, listen: false).deleteShot(projectId, sceneId, shot.id);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: lensController, decoration: const InputDecoration(labelText: 'Lens / Technical Notes')),
              const SizedBox(height: 16),
              _buildDropdown<ShotType>('Type', selectedType, ShotType.values, (val) => setState(() => selectedType = val!)),
              _buildDropdown<CameraAngle>('Angle', selectedAngle, CameraAngle.values, (val) => setState(() => selectedAngle = val!)),
              _buildDropdown<CameraMovement>('Movement', selectedMovement, CameraMovement.values, (val) => setState(() => selectedMovement = val!)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    shot.title = titleController.text;
                    shot.lens = lensController.text;
                    shot.type = selectedType;
                    shot.angle = selectedAngle;
                    shot.movement = selectedMovement;
                    Provider.of<AppProvider>(context, listen: false).updateShot(projectId, sceneId, shot);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('SAVE CHANGES', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
