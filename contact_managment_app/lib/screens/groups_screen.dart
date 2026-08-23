import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/group_model.dart';
import '../theme/app_theme.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<GroupModel> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshGroups();
  }

  Future<void> _refreshGroups() async {
    setState(() => _isLoading = true);
    final groups = await DatabaseHelper.instance.readAllGroups();
    setState(() {
      _groups = groups;
      _isLoading = false;
    });
  }

  Future<void> _addOrEditGroup({GroupModel? group}) async {
    final controller = TextEditingController(text: group?.name ?? '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(group == null ? 'Add Group' : 'Edit Group'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Group Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(group == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );

    if (confirmed == true && controller.text.isNotEmpty) {
      if (group == null) {
        await DatabaseHelper.instance.createGroup(GroupModel(name: controller.text));
      } else {
        await DatabaseHelper.instance.updateGroup(GroupModel(id: group.id, name: controller.text));
      }
      _refreshGroups();
    }
  }

  Future<void> _deleteGroup(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text('Are you sure you want to delete this group? Contacts in this group will not be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteGroup(id);
      _refreshGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Groups'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? const Center(child: Text('No groups yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.folder, color: AppTheme.coralPink),
                        title: Text(group.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppTheme.plum),
                              onPressed: () => _addOrEditGroup(group: group),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteGroup(group.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditGroup(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
