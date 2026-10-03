import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../booking/booking_stepper_screen.dart';

class SalonDetailsScreen extends StatelessWidget {
  const SalonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1074&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Luxe Beauty Lounge',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainText,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 20.0),
                              SizedBox(width: 4.0),
                              Text('4.9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                              Text(' (240 Reviews)', style: TextStyle(color: AppColors.secondaryText)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.softRose,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 18.0),
                      const SizedBox(width: 8.0),
                      const Text('Beverly Hills, CA', style: TextStyle(color: AppColors.secondaryText)),
                      const Spacer(),
                      const Text('Open Now', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 48.0),
                  Text('About', style: GoogleFonts.playfairDisplay(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Glamora Beauty offers a premium experience where your style meets our expertise. Our stylists are dedicated to providing the best hair, nail, and skin treatments in a luxurious environment.',
                    style: TextStyle(color: AppColors.secondaryText, height: 1.6),
                  ),
                  const SizedBox(height: 32.0),
                  Text('Services', style: GoogleFonts.playfairDisplay(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16.0),
                  _serviceTile('Master Haircut', 'Consultation + Wash + Cut', r'$65'),
                  _serviceTile('Glow Facial', 'Deep cleansing for radiant skin', r'$45'),
                  _serviceTile('Gel Manicure', 'Long-lasting professional finish', r'$35'),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0, offset: const Offset(0, -5.0))],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingStepperScreen()));
          },
          child: const Text('Book Now'),
        ),
      ),
    );
  }

  Widget _serviceTile(String name, String desc, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              const SizedBox(height: 4.0),
              Text(desc, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12.0)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 18.0)),
        ],
      ),
    );
  }
}
