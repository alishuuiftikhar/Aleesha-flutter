import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/auth_notifier.dart';
import '../../widgets/category_item.dart';
import '../../widgets/salon_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(authProvider).profile;
    final userName = profile?.fullName.split(' ').first ?? 'Guest';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning ✨',
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.mainText,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Let’s find your next glow-up, $userName',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary, width: 2.0),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: AppColors.softRose,
                        backgroundImage: profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null,
                        child: profile?.avatarUrl == null ? const Icon(Icons.person, color: AppColors.primary) : null,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.05),
                        blurRadius: 10.0,
                        offset: const Offset(0, 5.0),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search salons or services...',
                      icon: Icon(Icons.search, color: AppColors.primary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Promotional Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: double.infinity,
                  height: 160.0,
                  decoration: BoxDecoration(
                    gradient: AppColors.luxuryGradient,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10.0,
                        bottom: -10.0,
                        child: Icon(Icons.auto_awesome, size: 120.0, color: Colors.white.withOpacity(0.1)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'GLAMORA REWARDS 👑',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12.0),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Earn 2x Points',
                              style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'On all facial treatments',
                              style: TextStyle(color: Colors.white, fontSize: 14.0),
                            ),
                            const SizedBox(height: 12.0),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primary,
                                minimumSize: const Size(120.0, 36.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              ),
                              child: const Text('Claim Offer'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('Categories', style: GoogleFonts.playfairDisplay(fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.mainText)),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 110.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: const [
                    CategoryItem(title: 'Hair', icon: Icons.content_cut),
                    CategoryItem(title: 'Makeup', icon: Icons.brush),
                    CategoryItem(title: 'Nails', icon: Icons.back_hand),
                    CategoryItem(title: 'Facial', icon: Icons.face),
                    CategoryItem(title: 'Spa', icon: Icons.spa),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Loyalty Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.softRose,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: AppColors.primary, size: 40.0),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Glow Starter 🌸',
                              style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18.0, color: AppColors.mainText),
                            ),
                            Text(
                              '450 points to your next reward',
                              style: TextStyle(color: AppColors.secondaryText, fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // Featured Salons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Premium Salons', style: GoogleFonts.playfairDisplay(fontSize: 20.0, fontWeight: FontWeight.bold, color: AppColors.mainText)),
                    TextButton(onPressed: () {}, child: const Text('Explore all')),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Horizontal Salon Cards
              SizedBox(
                height: 350.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const SizedBox(
                      width: 300.0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: SalonCard(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
