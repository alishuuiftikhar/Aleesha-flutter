import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/astronomy_object.dart';
import '../services/astronomy_provider.dart';
import '../utils/constants.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  AstronomyObject? _leftObject;
  AstronomyObject? _rightObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('COMPARE OBJECTS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSelector(context, true)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('VS', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent)),
                ),
                Expanded(child: _buildSelector(context, false)),
              ],
            ),
            const SizedBox(height: 24),
            if (_leftObject != null && _rightObject != null)
              Expanded(child: _buildComparisonTable())
            else
              const Expanded(child: Center(child: Text('Select two objects to compare properties.'))),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(BuildContext context, bool isLeft) {
    final selected = isLeft ? _leftObject : _rightObject;
    return GestureDetector(
      onTap: () => _showObjectPicker(context, isLeft),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          image: selected != null ? DecorationImage(image: NetworkImage(selected.image), fit: BoxFit.cover, opacity: 0.5) : null,
        ),
        child: Center(
          child: Text(
            selected?.name ?? 'Select Object',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showObjectPicker(BuildContext context, bool isLeft) {
    final objects = Provider.of<AstronomyProvider>(context, listen: false).objects;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.mainBackground,
      builder: (_) => ListView.builder(
        itemCount: objects.length,
        itemBuilder: (ctx, index) {
          final obj = objects[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(obj.image)),
            title: Text(obj.name),
            subtitle: Text(obj.category),
            onTap: () {
              setState(() {
                if (isLeft) _leftObject = obj;
                else _rightObject = obj;
              });
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }

  Widget _buildComparisonTable() {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildComparisonRow('Category', _leftObject!.category, _rightObject!.category),
              _buildComparisonRow('Distance', _leftObject!.distance ?? 'N/A', _rightObject!.distance ?? 'N/A'),
              _buildComparisonRow('Size', _leftObject!.size ?? 'N/A', _rightObject!.size ?? 'N/A'),
              _buildComparisonRow('Facts Count', _leftObject!.facts.length.toString(), _rightObject!.facts.length.toString()),
              const SizedBox(height: 16),
              const Text('Description Summary', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(_leftObject!.description, style: const TextStyle(fontSize: 12))),
                  const SizedBox(width: 16),
                  Expanded(child: Text(_rightObject!.description, style: const TextStyle(fontSize: 12))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(left, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 40),
              Expanded(child: Text(right, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(color: Colors.white10),
        ],
      ),
    );
  }
}
