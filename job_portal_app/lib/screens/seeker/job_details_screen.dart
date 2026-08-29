import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'application_form_screen.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final company = job['companies'] ?? {};
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: company['logo_url'] != null
                        ? Image.network(company['logo_url'], errorBuilder: (_, __, ___) => const Icon(Icons.business, size: 40))
                        : const Icon(Icons.business, size: 40, color: AppConstants.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    job['title'] ?? 'Job Title',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    company['name'] ?? 'Company Name',
                    style: const TextStyle(fontSize: 18, color: AppConstants.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Job Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Location', job['location'] ?? 'Remote', Icons.location_on),
                _buildStat('Job Type', job['job_type'] ?? 'Full-time', Icons.work),
                _buildStat('Salary', '\$${job['salary_min']/1000}k-\$${job['salary_max']/1000}k', Icons.payments),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Job Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              job['description'] ?? 'No description provided.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 32),
            const Text('Requirements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              job['requirements'] ?? 'No requirements provided.',
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppConstants.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicationFormScreen(job: job),
                  ),
                ),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Apply Now', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
