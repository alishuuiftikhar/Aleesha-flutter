import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Appointments', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondaryText,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingList('upcoming'),
            _buildBookingList('pending'),
            _buildBookingList('completed'),
            _buildBookingList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: 2,
      itemBuilder: (context, index) {
        return _buildBookingCard(type);
      },
    );
  }

  Widget _buildBookingCard(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Oct 24, 2023 - 10:00 AM', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13.0)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(color: AppColors.softRose, borderRadius: BorderRadius.circular(8.0)),
                child: Text(type.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 10.0, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1074&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Classic Haircut', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    Text('with Emma Wilson', style: const TextStyle(color: AppColors.secondaryText, fontSize: 14.0)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              if (type == 'upcoming' || type == 'pending') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      side: BorderSide(color: AppColors.error.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
              if (type == 'completed') ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Rebook ✨'),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Leave Review'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
