import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../core/constants.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = context.watch<PropertyProvider>().compareList;

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Properties')),
      body: properties.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.compare_arrows, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Add properties from details page to compare (max 3)', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.secondaryBackground),
                    dataRowColor: WidgetStateProperty.all(Colors.white),
                    columns: properties.map((p) => DataColumn(
                      label: SizedBox(
                        width: 120,
                        child: Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      )
                    )).toList(),
                    rows: [
                      DataRow(cells: properties.map((p) => DataCell(Text('\$${p.price.toInt()}${p.type == 'Rent' ? '/mo' : ''}'))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text(p.type))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text(p.category))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text('${p.bedrooms} Beds'))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text('${p.bathrooms} Baths'))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text('${p.area.toInt()} sqft'))).toList()),
                      DataRow(cells: properties.map((p) => DataCell(Text(p.city))).toList()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<PropertyProvider>().compareList.clear();
                      // This is a bit hacky but for simplicity:
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Comparison', style: TextStyle(color: Colors.red)),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
