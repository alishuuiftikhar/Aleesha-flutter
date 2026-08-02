import 'package:flutter/material.dart';

void main() => runApp(const NexusWalletApp());

class NexusWalletApp extends StatelessWidget {
  const NexusWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Fintech & Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const WalletHomeScreen(),
    );
  }
}

class WalletHomeScreen extends StatefulWidget {
  const WalletHomeScreen({super.key});

  @override
  State<WalletHomeScreen> createState() => _WalletHomeScreenState();
}

class _WalletHomeScreenState extends State<WalletHomeScreen> {
  bool _isBalanceVisible = true;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Apple Store Purchase', 'category': 'Electronics', 'amount': '- \$1,299.00', 'time': 'Today, 2:45 PM', 'isExpense': true, 'icon': Icons.apple},
    {'title': 'Client Salary Deposit', 'category': 'Income', 'amount': '+ \$4,850.00', 'time': 'Yesterday, 10:15 AM', 'isExpense': false, 'icon': Icons.account_balance_wallet},
    {'title': 'Starbucks Coffee', 'category': 'Food & Drinks', 'amount': '- \$6.50', 'time': 'Yesterday, 8:30 AM', 'isExpense': true, 'icon': Icons.coffee},
    {'title': 'Uber Ride Home', 'category': 'Transport', 'amount': '- \$24.20', 'time': 'Oct 24, 7:10 PM', 'isExpense': true, 'icon': Icons.local_taxi},
    {'title': 'Netflix Subscription', 'category': 'Entertainment', 'amount': '- \$15.99', 'time': 'Oct 22, 4:00 PM', 'isExpense': true, 'icon': Icons.tv},
  ];

  // 1. Send Money Bottom Sheet
  void _showSendSheet(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Send Money Securely', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Recipient Email or Phone',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (\$)',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (amountController.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully sent \$${amountController.text}!'), backgroundColor: Colors.green),
                    );
                  }
                },
                child: const Text('Transfer Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 2. Request Money Bottom Sheet
  void _showRequestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Request Funds', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'From (Email / Phone)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Request Amount (\$)', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment request sent successfully!')));
                },
                child: const Text('Send Request', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 3. Analytics Popup Dialog
  void _showAnalytics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Monthly Financial Insights'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Income: \$4,850.00', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text('Total Expenses: \$1,346.19', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
            Divider(height: 24),
            Text('🌟 Great job! You saved 72% of your total earnings this month.', style: TextStyle(fontSize: 13, color: Colors.indigo)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
        ],
      ),
    );
  }

  // 4. Notifications Panel
  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications & Alerts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.security, color: Colors.indigo),
              title: Text('New Login Detected'),
              subtitle: Text('Authorized sign-in from iPhone 15 Pro.'),
              trailing: Text('2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Cashback Received'),
              subtitle: Text('You got \$12.50 reward cashback.'),
              trailing: Text('Yesterday', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _transactions.where((tx) {
      return tx['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx['category'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF4F46E5), width: 2)),
              child: const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80')),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back,', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text('Sarah Jenkins', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Credit Card Widget
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1), Color(0xFF818CF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.indigo.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('NEXUS PLATINUM', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
                      Icon(Icons.contactless, color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _isBalanceVisible ? '\$28,450.80' : '••••••••',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
                        child: Icon(_isBalanceVisible ? Icons.visibility_off : Icons.visibility, color: Colors.white70, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('**** **** **** 4892', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 14)),
                      Text('09/26', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(icon: Icons.arrow_upward, label: 'Send', color: const Color(0xFF4F46E5), onTap: () => _showSendSheet(context)),
                _ActionButton(icon: Icons.arrow_downward, label: 'Request', color: Colors.teal, onTap: () => _showRequestSheet(context)),
                _ActionButton(icon: Icons.account_balance, label: 'Top-Up', color: Colors.blueAccent, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening secure top-up gateway...')));
                }),
                _ActionButton(icon: Icons.bar_chart, label: 'Analytics', color: Colors.purple, onTap: () => _showAnalytics(context)),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar for Transactions
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                TextButton(onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Showing complete transaction history')));
                }, child: const Text('See All')),
              ],
            ),
            const SizedBox(height: 8),

            // Transactions List
            filteredTransactions.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(child: Text('No transactions found', style: TextStyle(color: Colors.grey))),
            )
                : Column(
              children: filteredTransactions.map((tx) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (tx['isExpense'] ? Colors.red : Colors.green).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(tx['icon'], color: tx['isExpense'] ? Colors.red : Colors.green, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text(tx['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(
                      tx['amount'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: tx['isExpense'] ? Colors.redAccent : Colors.green),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }
}