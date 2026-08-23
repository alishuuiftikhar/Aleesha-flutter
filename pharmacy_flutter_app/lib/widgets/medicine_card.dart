import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/theme.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;

  const MedicineCard({super.key, required this.medicine, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: medicine.imageUrl != null
                    ? Image.network(
                        medicine.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.secondaryBackground,
                          child: const Icon(Icons.medication, size: 50, color: AppColors.accent),
                        ),
                      )
                    : Container(
                        color: AppColors.secondaryBackground,
                        child: const Icon(Icons.medication, size: 50, color: AppColors.accent),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${medicine.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: medicine.stock > 0 ? AppColors.highlight.withOpacity(0.2) : AppColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medicine.stock > 0 ? 'Stock: ${medicine.stock}' : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 12,
                        color: medicine.stock > 0 ? AppColors.accent : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
