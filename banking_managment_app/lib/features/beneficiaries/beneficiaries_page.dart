import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers.dart';
import '../../models/beneficiary.dart';

class BeneficiariesPage extends ConsumerWidget {
  const BeneficiariesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiariesAsync = ref.watch(beneficiariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Beneficiaries')),
      body: beneficiariesAsync.when(
        data: (beneficiaries) {
          if (beneficiaries.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: beneficiaries.length,
            itemBuilder: (context, index) {
              final beneficiary = beneficiaries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: Text(beneficiary.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(beneficiary.accountNumber, style: const TextStyle(color: AppColors.secondaryText)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, ref, beneficiary),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddBeneficiaryDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 64, color: AppColors.secondaryText),
          const SizedBox(height: 16),
          const Text('No beneficiaries yet', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add beneficiaries to transfer money quickly', style: TextStyle(color: AppColors.secondaryText)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showAddBeneficiaryDialog(context, ref),
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 45)),
            child: const Text('Add Beneficiary'),
          ),
        ],
      ),
    );
  }

  void _showAddBeneficiaryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final accountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Beneficiary'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: accountController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await ref.read(bankingRepositoryProvider).addBeneficiary(
                      nameController.text,
                      accountController.text,
                    );
                ref.invalidate(beneficiariesProvider);
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Beneficiary beneficiary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Beneficiary'),
        content: Text('Are you sure you want to remove ${beneficiary.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(bankingRepositoryProvider).removeBeneficiary(beneficiary.id);
              ref.invalidate(beneficiariesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
