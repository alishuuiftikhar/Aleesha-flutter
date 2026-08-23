import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../services/supabase_service.dart';
import '../../utils/theme.dart';
import 'add_edit_medicine_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAdminCard(context, 'Medicines', Icons.medication, () {
              // Show list of medicines for editing/deleting
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminMedicinesList()));
            }),
            _buildAdminCard(context, 'Orders', Icons.shopping_bag, () {
              Navigator.pushNamed(context, '/admin/orders');
            }),
            _buildAdminCard(context, 'Categories', Icons.category, () {
              Navigator.pushNamed(context, '/admin/categories');
            }),
            _buildAdminCard(context, 'Add Medicine', Icons.add_circle, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditMedicineScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class AdminMedicinesList extends StatelessWidget {
  const AdminMedicinesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Medicines')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.medicines.length,
            itemBuilder: (context, index) {
              final medicine = provider.medicines[index];
              return ListTile(
                title: Text(medicine.name),
                subtitle: Text('Stock: ${medicine.stock} | \$${medicine.price}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.accent),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditMedicineScreen(medicine: medicine),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.error),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.cardBackground,
                            title: const Text('Delete Medicine'),
                            content: const Text('Are you sure?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await SupabaseService().deleteMedicine(medicine.id);
                          if (context.mounted) {
                            Provider.of<AppProvider>(context, listen: false).fetchMedicines();
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
