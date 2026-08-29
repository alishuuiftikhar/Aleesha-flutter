import 'package:flutter/material.dart';
import '../models/traffic_sign.dart';
import '../theme/app_colors.dart';
import '../services/data_service.dart';

class SignDetailScreen extends StatefulWidget {
  final TrafficSign sign;
  const SignDetailScreen({super.key, required this.sign});

  @override
  State<SignDetailScreen> createState() => _SignDetailScreenState();
}

class _SignDetailScreenState extends State<SignDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: Text(widget.sign.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(widget.sign.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: widget.sign.isFavorite ? AppColors.error : null,
            onPressed: () async {
              await DataService().toggleFavorite(widget.sign.id);
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.white,
              padding: const EdgeInsets.all(40),
              child: Image.network(
                widget.sign.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sign.category,
                    style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.sign.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Meaning & Guidance:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.sign.description,
                    style: const TextStyle(fontSize: 18, height: 1.5, color: AppColors.text),
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
