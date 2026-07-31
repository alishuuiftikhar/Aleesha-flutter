import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class IssuedBooksScreen extends StatefulWidget {
  const IssuedBooksScreen({super.key});

  @override
  State<IssuedBooksScreen> createState() => _IssuedBooksScreenState();
}

class _IssuedBooksScreenState extends State<IssuedBooksScreen> {
  List<Map<String, dynamic>> _issuedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadIssuedBooks();
  }

  Future<void> _loadIssuedBooks() async {
    final data = await DatabaseHelper.instance.fetchIssuedBooks();
    setState(() {
      _issuedBooks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issued Books History & Return'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
      ),
      body: _issuedBooks.isEmpty
          ? const Center(
        child: Text(
          'No active book issues found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _issuedBooks.length,
        itemBuilder: (context, index) {
          final item = _issuedBooks[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.lightBlue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const Text('Issued 🔴', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
                const Divider(),
                Text('👤 Student Name: ${item['name']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text('🆔 Roll Number: ${item['roll_no']}', style: const TextStyle(fontSize: 14)),
                Text('📅 Issue Date: ${item['issue_date']}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await DatabaseHelper.instance.returnBook(item['issue_id'], item['book_id']);
                      await _loadIssuedBooks();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Book "${item['title']}" returned by ${item['name']} successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Return Book'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}