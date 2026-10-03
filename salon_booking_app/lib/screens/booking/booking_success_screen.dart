import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: AppColors.softRose, shape: BoxShape.circle),
                child: Icon(Icons.check_circle, color: AppColors.primary, size: 80),
              ),
              const SizedBox(height: 32),
              Text(
                'You’re all booked! 💕',
                style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.mainText),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your beauty appointment is confirmed. We can’t wait to see you!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow('Booking ID', '#GLM-2901'),
                    const Divider(height: 24),
                    _infoRow('Date', 'Oct 24, 2023'),
                    _infoRow('Time', '10:00 AM'),
                    _infoRow('Stylist', 'Emma Wilson'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Add to Calendar', style: TextStyle(color: AppColors.primary, decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.secondaryText)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainText)),
        ],
      ),
    );
  }
}
