import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import '../theme_constants.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                pet.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name, 
                              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(pet.distance, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Consumer<PetProvider>(
                        builder: (context, provider, child) {
                          final currentPet = provider.allPets.firstWhere(
                            (p) => p.id == pet.id, 
                            orElse: () => pet
                          );
                          return IconButton(
                            icon: Icon(
                              currentPet.isFavorite ? Icons.favorite : Icons.favorite_border, 
                              color: Colors.red, 
                              size: 35
                            ),
                            onPressed: () => provider.toggleFavorite(currentPet),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoCard('Age', pet.age),
                      _infoCard('Breed', pet.breed),
                      _infoCard('Sex', 'Male'),
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'About Me', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)
                  ),
                  const SizedBox(height: 15),
                  Text(
                    pet.description,
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.6),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _showAdoptionDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 65),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: const Text(
                      'ADOPT ME', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdoptionDialog(BuildContext context) {
    final provider = context.read<PetProvider>();
    final nameController = TextEditingController(text: provider.userName == 'enter your name' ? '' : provider.userName);
    final phoneController = TextEditingController(text: provider.phoneNumber);
    String selectedPayment = provider.paymentMethod;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Adopt ${pet.name}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                ),
                const SizedBox(height: 20),
                const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text('Card'),
                  value: 'Card',
                  groupValue: selectedPayment,
                  onChanged: (value) => setState(() => selectedPayment = value!),
                ),
                RadioListTile<String>(
                  title: const Text('Cash on Delivery'),
                  value: 'Cash on Delivery',
                  groupValue: selectedPayment,
                  onChanged: (value) => setState(() => selectedPayment = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                  provider.updateUserName(nameController.text);
                  provider.updatePhoneNumber(phoneController.text);
                  provider.updatePaymentMethod(selectedPayment);
                  provider.adoptPet(pet);
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to home
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Congratulations! ${pet.name} is now yours.')),
                  );
                }
              },
              child: const Text('Confirm Adoption'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 5),
          Text(
            value, 
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14), 
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
