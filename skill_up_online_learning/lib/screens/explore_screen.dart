import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Explore', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for courses...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0D9488)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryChip('Development'),
                _buildCategoryChip('Design'),
                _buildCategoryChip('Business'),
                _buildCategoryChip('Marketing'),
                _buildCategoryChip('Photography'),
                _buildCategoryChip('Music'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Top Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  _SearchResultItem(title: 'Web Development Bootcamp', instructor: 'Dr. Angela Yu', price: '\$19.99'),
                  _SearchResultItem(title: 'Graphic Design Masterclass', instructor: 'Lindsay Marsh', price: '\$14.99'),
                  _SearchResultItem(title: 'Digital Marketing 101', instructor: 'Rob Percival', price: '\$12.99'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: Color(0xFF0D9488)),
      side: const BorderSide(color: Color(0xFF0D9488)),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final String title, instructor, price;
  const _SearchResultItem({required this.title, required this.instructor, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF99F6E4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.book, color: Color(0xFF0D9488)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(instructor),
        trailing: Text(price, style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
      ),
    );
  }
}
