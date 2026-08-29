import 'package:flutter/material.dart';
import 'package:school_attendance_app/database/database_helper.dart';
import 'package:school_attendance_app/models/class_model.dart';
import 'package:school_attendance_app/models/subject.dart';
import 'package:school_attendance_app/theme/app_theme.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  List<ClassModel> _classes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() => _isLoading = true);
    final maps = await DatabaseHelper.instance.queryAllClasses();
    setState(() {
      _classes = maps.map((e) => ClassModel.fromMap(e)).toList();
      _isLoading = false;
    });
  }

  void _showEditClassDialog(ClassModel classModel) async {
    final controller = TextEditingController(text: classModel.name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Class Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Class Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.updateClass({
                  'id': classModel.id,
                  'name': controller.text.trim(),
                });
                Navigator.pop(context);
                _loadClasses();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteClassConfirmation(ClassModel classModel) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class?'),
        content: Text('Are you sure you want to delete ${classModel.name}? This will delete all subjects and students in this class.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteClass(classModel.id!);
              Navigator.pop(context);
              _loadClasses();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddClassDialog() async {
    final classController = TextEditingController();
    final subjectController = TextEditingController();
    List<String> tempSubjects = [];
    bool isSaving = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing while saving
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Class'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: classController,
                  enabled: !isSaving,
                  decoration: const InputDecoration(
                    labelText: 'Class Name',
                    hintText: 'e.g. Software Engineering',
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: subjectController,
                        enabled: !isSaving,
                        decoration: const InputDecoration(
                          hintText: 'Type subject name',
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppTheme.primary, size: 32),
                      onPressed: isSaving ? null : () {
                        if (subjectController.text.trim().isNotEmpty) {
                          setDialogState(() {
                            tempSubjects.add(subjectController.text.trim());
                            subjectController.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tempSubjects.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: tempSubjects
                        .map((s) => Chip(
                              label: Text(s, style: const TextStyle(fontSize: 12)),
                              backgroundColor: AppTheme.secondaryBackground,
                              onDeleted: isSaving ? null : () => setDialogState(() => tempSubjects.remove(s)),
                            ))
                        .toList(),
                  )
                else
                  const Text('No subjects added yet. Type & click +', 
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(context), 
              child: const Text('Cancel')
            ),
            isSaving 
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : ElevatedButton(
                  onPressed: () async {
                    String className = classController.text.trim();
                    
                    if (className.isNotEmpty) {
                      setDialogState(() => isSaving = true);
                      
                      try {
                        // Automatically add typed subject if not added via +
                        if (subjectController.text.trim().isNotEmpty) {
                          tempSubjects.add(subjectController.text.trim());
                        }

                        final classId = await DatabaseHelper.instance.insertClass({'name': className});
                        
                        for (var subjectName in tempSubjects) {
                          await DatabaseHelper.instance.insertSubject({
                            'name': subjectName,
                            'class_id': classId,
                          });
                        }
                        
                        Navigator.pop(context);
                        _loadClasses();
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Success: Saved $className')),
                        );
                      } catch (e) {
                        setDialogState(() => isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 8),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a Class Name')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
                  child: const Text('Save Class'),
                ),
          ],
        ),
      ),
    );
  }

  void _showSubjectsDialog(ClassModel classModel) async {
    final controller = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Subjects: ${classModel.name}'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(hintText: 'New subject name'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.primary),
                        onPressed: () async {
                          if (controller.text.trim().isNotEmpty) {
                            try {
                              await DatabaseHelper.instance.insertSubject({
                                'name': controller.text.trim(),
                                'class_id': classModel.id,
                              });
                              controller.clear();
                              setDialogState(() {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Flexible(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: DatabaseHelper.instance.querySubjectsByClass(classModel.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No subjects found.'),
                          );
                        }
                        
                        final subjectsList = snapshot.data!.map((e) => Subject.fromMap(e)).toList();
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: subjectsList.length,
                          itemBuilder: (context, index) {
                            final subject = subjectsList[index];
                            return ListTile(
                              title: Text(subject.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () {
                                      _showEditSubjectDialog(subject, () {
                                        setDialogState(() {});
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () async {
                                      await DatabaseHelper.instance.deleteSubject(subject.id!);
                                      setDialogState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditSubjectDialog(Subject subject, VoidCallback onUpdate) async {
    final controller = TextEditingController(text: subject.name);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subject Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.updateSubject(subject.id!, controller.text.trim());
                Navigator.pop(context);
                onUpdate();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes & Subjects')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final cls = _classes[index];
                return InkWell(
                  onTap: () => _showSubjectsDialog(cls),
                  child: Card(
                    color: AppTheme.secondaryBackground,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.class_rounded, size: 40, color: AppTheme.primary),
                              const SizedBox(height: 12),
                              Text(
                                cls.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tap to manage subjects',
                                style: TextStyle(fontSize: 10, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.more_vert, size: 20),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditClassDialog(cls);
                              } else if (value == 'delete') {
                                _showDeleteClassConfirmation(cls);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Edit Name'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete Class'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
