import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/property.dart';
import '../core/constants.dart';
import '../providers/property_provider.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'property_image_${property.id}',
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    autoPlay: property.images.isNotEmpty,
                  ),
                  items: [
                    property.mainImage ?? 'https://via.placeholder.com/600x400',
                    ...property.images,
                  ].map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              Consumer<PropertyProvider>(
                builder: (context, provider, _) => IconButton(
                  icon: CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(
                      property.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: property.isFavorite ? Colors.red : Colors.black,
                    ),
                  ),
                  onPressed: () => provider.toggleFavorite(property),
                ),
              ),
              const SizedBox(width: 8),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          property.type,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        currencyFormat.format(property.price) + (property.type == 'Rent' ? '/mo' : ''),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(property.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text('${property.address}, ${property.city}', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailIcon(Icons.bed, '${property.bedrooms} Beds'),
                      _buildDetailIcon(Icons.bathtub, '${property.bathrooms} Baths'),
                      _buildDetailIcon(Icons.square_foot, '${property.area.toInt()} sqft'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    property.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 32),
                  const Text('Property Agent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (property.agent != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: property.agent!.profileImage != null ? NetworkImage(property.agent!.profileImage!) : null,
                            child: property.agent!.profileImage == null ? const Icon(Icons.person) : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(property.agent!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(property.agent!.agency, style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {}, // Contact agent
                            icon: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.phone, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showScheduleDialog(context),
                          child: const Text('Schedule Viewing'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<PropertyProvider>(
                        builder: (context, provider, _) {
                          bool isComparing = provider.compareList.contains(property);
                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(60, 50),
                              side: BorderSide(color: isComparing ? AppColors.accent : AppColors.primary),
                              backgroundColor: isComparing ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
                            ),
                            onPressed: () => provider.toggleCompare(property),
                            child: Icon(Icons.compare_arrows, color: isComparing ? AppColors.accent : AppColors.primary),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showScheduleDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
      );

      if (selectedTime != null) {
        final scheduledAt = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        if (!context.mounted) return;

        try {
          await context.read<PropertyProvider>().bookViewing(property.id, scheduledAt);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Viewing scheduled successfully!'), backgroundColor: Colors.green),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.error),
            );
          }
        }
      }
    }
  }
}
