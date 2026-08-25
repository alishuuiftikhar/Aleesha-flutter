import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/certificate_model.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';
import 'add_edit_certificate_screen.dart';

class CertificateDetailsScreen extends StatelessWidget {
  final Certificate certificate;

  const CertificateDetailsScreen({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditCertificateScreen(certificate: certificate)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(certificate.title, style: Theme.of(context).textTheme.displaySmall),
                ),
                Consumer<AppProvider>(
                  builder: (context, provider, child) => IconButton(
                    icon: Icon(
                      certificate.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: certificate.isFavorite ? AppColors.error : AppColors.secondaryText,
                      size: 28,
                    ),
                    onPressed: () => provider.toggleFavoriteCertificate(certificate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(certificate.organization, style: const TextStyle(color: AppColors.accent, fontSize: 18)),
            const SizedBox(height: 32),
            _buildDetailGrid(),
            const SizedBox(height: 32),
            if (certificate.description != null && certificate.description!.isNotEmpty) ...[
              const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(certificate.description!, style: const TextStyle(color: AppColors.secondaryText)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (certificate.imagePath != null) {
          _showFullScreenImage(context);
        }
      },
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          image: certificate.imagePath != null
              ? DecorationImage(image: FileImage(File(certificate.imagePath!)), fit: BoxFit.contain)
              : null,
        ),
        child: certificate.imagePath == null
            ? const Icon(Icons.card_membership, size: 80, color: AppColors.primary)
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: const Icon(Icons.fullscreen, color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildInfoItem('Issue Date', DateFormat('MMM dd, yyyy').format(certificate.issueDate)),
        _buildInfoItem('Category', certificate.category),
        _buildInfoItem('Certificate ID', certificate.certificateId ?? 'N/A'),
        _buildInfoItem('Status', certificate.status),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(certificate.imagePath!)),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Certificate?'),
        content: const Text('Are you sure you want to remove this certificate?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).deleteCertificate(certificate.id!).then((_) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
