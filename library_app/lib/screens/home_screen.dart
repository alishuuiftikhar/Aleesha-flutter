import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'student_screen.dart';
import 'issued_books_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _books = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final books = await DatabaseHelper.instance.fetchBooks(query: _searchQuery);
    setState(() {
      _books = books;
    });
  }

  // Book Issue Dialog with Student Name & Roll Number Input
  void _showIssueDialog(int bookId, String bookTitle) {
    final nameController = TextEditingController();
    final rollController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Issue: $bookTitle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter Student Details:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(labelText: 'Roll Number', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty && rollController.text.trim().isNotEmpty) {
                await DatabaseHelper.instance.issueBookWithStudent(
                  bookId: bookId,
                  studentName: nameController.text.trim(),
                  rollNo: rollController.text.trim(),
                );
                await _loadData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Book issued successfully to ${nameController.text.trim()}!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill both Name and Roll Number!')),
                );
              }
            },
            child: const Text('Confirm Issue'),
          ),
        ],
      ),
    );
  }

  // Book Add/Update Dialog
  void _showBookDialog({Map<String, dynamic>? book}) {
    final titleController = TextEditingController(text: book?['title'] ?? '');
    final authorController = TextEditingController(text: book?['author'] ?? '');
    final categoryController = TextEditingController(text: book?['category'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book == null ? 'Add Book' : 'Update Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Book Title')),
            TextField(controller: authorController, decoration: const InputDecoration(labelText: 'Author Name')),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                if (book == null) {
                  await DatabaseHelper.instance.insertBook({
                    'title': titleController.text.trim(),
                    'author': authorController.text.trim(),
                    'category': categoryController.text.trim().isEmpty ? 'General' : categoryController.text.trim(),
                    'is_available': 1,
                  });
                } else {
                  await DatabaseHelper.instance.updateBook({
                    'id': book['id'],
                    'title': titleController.text.trim(),
                    'author': authorController.text.trim(),
                    'category': categoryController.text.trim(),
                    'is_available': book['is_available'],
                  });
                }
                await _loadData();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🩵 Digital Library System'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Students Record',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentsScreen())).then((_) => _loadData()),
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            tooltip: 'Issued Books History',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IssuedBooksScreen())).then((_) => _loadData()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Books by Title or Author',
                prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
                _loadData();
              },
            ),
          ),
          Expanded(
            child: _books.isEmpty
                ? const Center(child: Text('No books found. Add a book!'))
                : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                bool isAvailable = book['is_available'] == 1;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () {
                      if (isAvailable) {
                        _showIssueDialog(book['id'], book['title']);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('This book is already issued!')),
                        );
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: isAvailable ? Colors.lightBlue.shade100 : Colors.red.shade100,
                      child: Icon(Icons.book, color: isAvailable ? Colors.lightBlue : Colors.red),
                    ),
                    title: Text(book['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Author: ${book['author']}\nStatus: ${isAvailable ? "Available 🟢" : "Issued 🔴"} (Click to Issue)'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isAvailable
                            ? IconButton(
                          icon: const Icon(Icons.bookmark_add, color: Colors.green),
                          onPressed: () => _showIssueDialog(book['id'], book['title']),
                        )
                            : const SizedBox.shrink(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showBookDialog(book: book),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteBook(book['id']);
                            await _loadData();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}