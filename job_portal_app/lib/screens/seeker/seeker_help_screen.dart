import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class SeekerHelpScreen extends StatelessWidget {
  const SeekerHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildFAQItem(
              'How to apply for a job?',
              'Browse jobs in the "Jobs" tab, click on a job to see details, and then click "Apply Now" to upload your resume.',
            ),
            _buildFAQItem(
              'How to track applications?',
              'Go to the "Applications" tab in the bottom navigation to see the status of all your submitted applications.',
            ),
            _buildFAQItem(
              'How to edit my profile?',
              'Go to the "Profile" tab and click "Edit Profile" to update your name, phone, and bio.',
            ),
            const SizedBox(height: 40),
            const Text(
              'Still need help?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.email),
              label: const Text('Contact Support'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}
