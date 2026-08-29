import 'package:flutter/material.dart';
import '../models/travel_package.dart';
import '../theme.dart';

class PackageDetailsScreen extends StatelessWidget {
  final TravelPackage package;

  const PackageDetailsScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 25),
                  _buildDurationAndPrice(),
                  const SizedBox(height: 25),
                  _buildDescription(),
                  const SizedBox(height: 25),
                  _buildActivitiesList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(package.imageUrl, fit: BoxFit.cover),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          package.name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: TravelTheme.textMain,
          ),
        ),
        Text(
          package.destination,
          style: const TextStyle(color: TravelTheme.primary, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildDurationAndPrice() {
    return Row(
      children: [
        _infoChip(Icons.timer, '${package.durationDays} Days'),
        const SizedBox(width: 15),
        _infoChip(Icons.payments, '\$${package.pricePerPerson} / Person'),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TravelTheme.bgSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: TravelTheme.accent, size: 18),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: TravelTheme.textMain)),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Package Description',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
        ),
        const SizedBox(height: 10),
        Text(
          package.description,
          style: TextStyle(color: TravelTheme.textSecondary.withOpacity(0.8), fontSize: 15, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildActivitiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Included Activities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TravelTheme.textMain),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: package.activities.map((act) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: TravelTheme.cardBg.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TravelTheme.cardBg),
            ),
            child: Text(act, style: const TextStyle(color: TravelTheme.textMain)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Package booking coming soon!')),
          );
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
        ),
        child: const Text('Book This Package', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
