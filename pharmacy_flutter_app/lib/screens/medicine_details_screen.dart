import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medicine.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int quantity = 1;
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.medicine.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
              ),
              child: widget.medicine.imageUrl != null
                  ? Image.network(widget.medicine.imageUrl!, fit: BoxFit.cover)
                  : const Icon(Icons.medication, size: 120, color: AppColors.accent),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.medicine.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$${widget.medicine.price}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.highlight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Stock: ${widget.medicine.stock}',
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.medicine.description,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Text('Quantity:', style: TextStyle(fontSize: 18)),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          if (quantity < widget.medicine.stock) setState(() => quantity++);
                        },
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.medicine.stock > 0 && !isAdding
                          ? () async {
                              setState(() => isAdding = true);
                              try {
                                await Provider.of<AppProvider>(context, listen: false)
                                    .addToCart(widget.medicine.id, quantity);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added to cart!'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => isAdding = false);
                              }
                            }
                          : null,
                      child: isAdding
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(widget.medicine.stock > 0 ? 'Add to Cart' : 'Out of Stock'),
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
