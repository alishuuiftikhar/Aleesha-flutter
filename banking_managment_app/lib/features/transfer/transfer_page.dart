import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../providers.dart';
import '../../models/account.dart';
import '../../models/beneficiary.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key});

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _accountNumberController = TextEditingController();
  
  Account? _selectedFromAccount;
  Beneficiary? _selectedBeneficiary;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accounts = ref.read(accountsProvider).value;
      if (accounts != null && accounts.isNotEmpty) {
        setState(() {
          _selectedFromAccount = ref.read(selectedAccountProvider) ?? accounts.first;
        });
      }
    });
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFromAccount == null) return;

    final amount = double.parse(_amountController.text);
    final targetAccount = _selectedBeneficiary?.accountNumber ?? _accountNumberController.text;

    // Show confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Text('Are you sure you want to transfer \$${amount.toStringAsFixed(2)} to $targetAccount?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(bankingRepositoryProvider).transferMoney(
        fromAccountId: _selectedFromAccount!.id,
        toAccountNumber: targetAccount,
        amount: amount,
        description: _descController.text.isEmpty ? 'Transfer' : _descController.text,
      );
      
      if (mounted) {
        ref.invalidate(accountsProvider);
        ref.invalidate(transactionsProvider(_selectedFromAccount!.id));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transfer Successful!'), backgroundColor: AppColors.primary),
        );
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer Failed: ${e.toString()}'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final beneficiariesAsync = ref.watch(beneficiariesProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer Money')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('From Account', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              accountsAsync.when(
                data: (accounts) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borders),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Account>(
                      value: _selectedFromAccount,
                      isExpanded: true,
                      dropdownColor: AppColors.cardBackground,
                      items: accounts.map((acc) {
                        return DropdownMenuItem(
                          value: acc,
                          child: Text('${acc.accountType} (**** ${acc.accountNumber.substring(acc.accountNumber.length - 4)}) - ${currencyFormat.format(acc.balance)}'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedFromAccount = val),
                    ),
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading accounts'),
              ),
              const SizedBox(height: 24),
              const Text('To Beneficiary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              beneficiariesAsync.when(
                data: (beneficiaries) => Column(
                  children: [
                    if (beneficiaries.isNotEmpty) ...[
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: beneficiaries.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _selectedBeneficiary = null;
                                  _accountNumberController.clear();
                                }),
                                child: _buildBeneficiaryAvatar(null, 'New'),
                              );
                            }
                            final ben = beneficiaries[index - 1];
                            return GestureDetector(
                              onTap: () => setState(() {
                                _selectedBeneficiary = ben;
                                _accountNumberController.text = ben.accountNumber;
                              }),
                              child: _buildBeneficiaryAvatar(ben, ben.name),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _accountNumberController,
                      enabled: _selectedBeneficiary == null,
                      decoration: const InputDecoration(
                        labelText: 'Account Number',
                        prefixIcon: Icon(Icons.account_box_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter account number';
                        return null;
                      },
                    ),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Error loading beneficiaries'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter amount';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'Please enter a valid amount';
                  if (_selectedFromAccount != null && amount > _selectedFromAccount!.balance) {
                    return 'Insufficient balance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleTransfer,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('TRANSFER NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBeneficiaryAvatar(Beneficiary? beneficiary, String label) {
    final isSelected = _selectedBeneficiary?.id == beneficiary?.id;
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: isSelected ? AppColors.primary : AppColors.cardBackground,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.cardBackground,
              child: Icon(
                beneficiary == null ? Icons.add : Icons.person,
                color: isSelected ? AppColors.primary : AppColors.secondaryText,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.secondaryText,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
