import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../providers.dart';
import '../../models/account.dart';
import '../../models/transaction.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMERALD'),
        leading: IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () => context.push('/notifications'),
        ),
        actions: [
          profileAsync.when(
            data: (profile) => GestureDetector(
              onTap: () => context.push('/profile'),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    profile.fullName.isNotEmpty ? profile.fullName[0] : 'U',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(accountsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileAsync.when(
                data: (profile) => Text(
                  'Hello, ${profile.fullName}',
                  style: const TextStyle(color: AppColors.secondaryText, fontSize: 16),
                ),
                loading: () => const Text('Loading...', style: TextStyle(color: AppColors.secondaryText)),
                error: (_, __) => const Text('Hello User'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Good Morning',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              accountsAsync.when(
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return _buildEmptyAccount(context);
                  }
                  return _buildAccountsSection(context, ref, accounts);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error loading accounts: $err')),
              ),
              const SizedBox(height: 32),
              _buildQuickActions(context),
              const SizedBox(height: 32),
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildRecentTransactions(ref),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transfer'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Beneficiary'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) context.push('/transfer');
          if (index == 2) context.push('/beneficiaries');
          if (index == 3) context.push('/profile');
        },
      ),
    );
  }

  Widget _buildEmptyAccount(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borders),
      ),
      child: Column(
        children: [
          const Icon(Icons.account_balance_wallet, size: 48, color: AppColors.secondaryText),
          const SizedBox(height: 16),
          const Text('No accounts found', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Contact support to open a new account',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  Widget _buildAccountsSection(BuildContext context, WidgetRef ref, List<Account> accounts) {
    final selectedAccount = ref.watch(selectedAccountProvider) ?? accounts.first;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: accounts.length,
            onPageChanged: (index) {
              ref.read(selectedAccountProvider.notifier).state = accounts[index];
            },
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.cardBackground],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borders, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(account.accountType,
                            style: const TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
                        const Icon(Icons.credit_card, color: AppColors.accent),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      currencyFormat.format(account.balance),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.mainText),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '**** **** **** ${account.accountNumber.substring(account.accountNumber.length - 4)}',
                      style: const TextStyle(color: AppColors.secondaryText, letterSpacing: 2),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            accounts.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (ref.watch(selectedAccountProvider) ?? accounts.first).id == accounts[index].id
                    ? AppColors.primary
                    : AppColors.borders,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionItem(context, Icons.send, 'Transfer', () => context.push('/transfer')),
        _quickActionItem(context, Icons.receipt_long, 'Bills', () {}),
        _quickActionItem(context, Icons.add_circle_outline, 'Top Up', () {}),
        _quickActionItem(context, Icons.more_horiz, 'More', () {}),
      ],
    );
  }

  Widget _quickActionItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borders),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return accountsAsync.when(
      data: (accounts) {
        if (accounts.isEmpty) return const SizedBox.shrink();
        final selectedAccount = ref.watch(selectedAccountProvider) ?? accounts.first;
        final transactionsAsync = ref.watch(transactionsProvider(selectedAccount.id));

        return transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('No recent transactions', style: TextStyle(color: AppColors.secondaryText)),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 5 ? 5 : transactions.length,
              separatorBuilder: (_, __) => const Divider(color: AppColors.borders, height: 1),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isDebit = tx.fromAccountId == selectedAccount.id;
                final currencyFormat = NumberFormat.currency(symbol: '\$');

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDebit ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDebit ? Icons.arrow_outward : Icons.arrow_downward,
                      color: isDebit ? Colors.redAccent : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('MMM dd, yyyy').format(tx.createdAt),
                      style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                  trailing: Text(
                    '${isDebit ? "-" : "+"}${currencyFormat.format(tx.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDebit ? Colors.redAccent : AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    // Show details
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error: $err'),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
