import 'package:flutter/material.dart';

void main() => runApp(const StudyApp());

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: const Color(0xFFFCE7F3)),
      home: const StudyNotesScreen(),
    );
  }
}

class NoteItem {
  final String title, description, subject, date;
  NoteItem({required this.title, required this.description, required this.subject, required this.date});
}

class StudyNotesScreen extends StatefulWidget {
  const StudyNotesScreen({super.key});
  @override
  State<StudyNotesScreen> createState() => _StudyNotesScreenState();
}

class _StudyNotesScreenState extends State<StudyNotesScreen> {
  final List<NoteItem> _savedNotes = [];
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedSubject = 'Physics';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final t = _titleController.text.trim(), d = _descController.text.trim();
    if (t.isEmpty || d.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields!'), backgroundColor: Colors.redAccent));
      return;
    }
    final now = DateTime.now();
    setState(() {
      _savedNotes.insert(0, NoteItem(title: t, description: d, subject: _selectedSubject, date: "${now.day}/${now.month}/${now.year}"));
      _titleController.clear(); _descController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  InlineSpan _noteSpan(String label, String val) {
    return TextSpan(children: [
      TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: "$val\n"),
    ]);
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFCE7F3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('STUDY NOTES HISTORY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 12),
            Expanded(
              child: _savedNotes.isEmpty
                  ? const Center(child: Text('No notes in history!', style: TextStyle(fontWeight: FontWeight.bold)))
                  : ListView.builder(
                itemCount: _savedNotes.length,
                itemBuilder: (context, i) => Card(
                  color: Colors.white,
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black, fontSize: 13, height: 1.3),
                        children: [_noteSpan("Title: ", _savedNotes[i].title), _noteSpan("Note: ", _savedNotes[i].description), _noteSpan("Date: ", _savedNotes[i].date)],
                      ),
                    ),
                    trailing: Chip(
                      label: Text(_savedNotes[i].subject, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      backgroundColor: const Color(0xFF0EA5E9),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STUDY NOTES KEEPER', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), centerTitle: true, backgroundColor: const Color(0xFF0EA5E9)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(hintText: 'Note Title...', prefixIcon: const Icon(Icons.title, color: Color(0xFF0EA5E9)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: const Color(0xFFF3E8FF)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: const Color(0xFFF3E8FF), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSubject,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9)),
                          items: ['Physics', 'Chemistry', 'Biology', 'Maths', 'English'].map((sub) => DropdownMenuItem(value: sub, child: Text(sub))).toList(),
                          onChanged: (val) { if (val != null) setState(() => _selectedSubject = val); },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController, maxLines: 2,
                  decoration: InputDecoration(hintText: 'Write formulas, notes...', prefixIcon: const Icon(Icons.description, color: Color(0xFF0EA5E9)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: const Color(0xFFF3E8FF)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(onPressed: _saveNote, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('SAVE NOTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _showHistorySheet, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('SEE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _savedNotes.isEmpty
                ? const Center(child: Text('No notes saved yet!', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _savedNotes.length,
              itemBuilder: (context, i) => Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13, height: 1.3),
                      children: [_noteSpan("Title: ", _savedNotes[i].title), _noteSpan("Note: ", _savedNotes[i].description), _noteSpan("Date: ", _savedNotes[i].date)],
                    ),
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Chip(label: Text(_savedNotes[i].subject, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)), backgroundColor: const Color(0xFF0EA5E9)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20), onPressed: () => setState(() => _savedNotes.removeAt(i))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}