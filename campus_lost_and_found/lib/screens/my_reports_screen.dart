import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/item.dart';
import '../models/claim.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';
import 'report_form_screen.dart';
import '../theme/app_theme.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Activities'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Reports'),
              Tab(text: 'My Claims'),
            ],
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _MyReportsList(),
            _MyClaimsList(),
          ],
        ),
      ),
    );
  }
}

class _MyReportsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final myReports = provider.items.where((i) => i.reporterId == provider.currentUserId).toList();
        
        if (myReports.isEmpty) {
          return const Center(child: Text('You haven\'t reported any items yet.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myReports.length,
          itemBuilder: (context, index) {
            final item = myReports[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.type == ReportType.lost ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                  child: Icon(
                    item.type == ReportType.lost ? Icons.help_outline : Icons.search,
                    color: item.type == ReportType.lost ? AppColors.error : AppColors.success,
                  ),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Status: ${item.status.name.toUpperCase()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportFormScreen(initialItem: item)),
                        );
                      },
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () {
                  _showClaimsForReport(context, item, provider);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showClaimsForReport(BuildContext context, LostFoundItem item, AppProvider provider) {
    final claims = provider.claims.where((c) => c.itemId == item.id).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Claims for: ${item.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (claims.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No claims received for this item yet.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: claims.length,
                    itemBuilder: (context, index) {
                      final claim = claims[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Claimant ID: ${claim.claimantId}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Proof: ${claim.proofDescription}'),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (claim.status == ClaimStatus.pending) ...[
                                    TextButton(
                                      onPressed: () async {
                                        await provider.updateClaimStatus(claim.id, ClaimStatus.rejected);
                                        if (context.mounted) Navigator.pop(context);
                                      },
                                      child: const Text('Reject', style: TextStyle(color: AppColors.error)),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showAcceptDialog(context, claim, item, provider);
                                      },
                                      child: const Text('Accept'),
                                    ),
                                  ] else ...[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Status: ${claim.status.name.toUpperCase()}',
                                          style: TextStyle(
                                            color: claim.status == ClaimStatus.accepted
                                                ? AppColors.success
                                                : AppColors.error,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (claim.returnMessage != null)
                                          Text('Instructions: ${claim.returnMessage}',
                                              style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
                    );
                  },
                  child: const Text('View Item Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAcceptDialog(BuildContext context, ItemClaim claim, LostFoundItem item, AppProvider provider) {
    final TextEditingController messageController =
        TextEditingController(text: "You can pick this up at the Student Union desk.");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Return'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Where should the person pick up this item? Enter instructions below:'),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(hintText: 'e.g. Meet at the Science building foyer at 2pm.'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await provider.updateClaimStatus(claim.id, ClaimStatus.accepted, returnMessage: messageController.text);
              await provider.updateItem(item.copyWith(status: ItemStatus.returned));
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close bottom sheet
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Claim accepted and instructions sent!')),
                );
              }
            },
            child: const Text('Confirm & Send'),
          ),
        ],
      ),
    );
  }
}

class _MyClaimsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final myClaims = provider.claims.where((c) => c.claimantId == provider.currentUserId).toList();

        if (myClaims.isEmpty) {
          return const Center(child: Text('You haven\'t made any claims yet.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myClaims.length,
          itemBuilder: (context, index) {
            final claim = myClaims[index];
            final item = provider.items.firstWhere((i) => i.id == claim.itemId, orElse: () => provider.items.first);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Claim Status: ${claim.status.name.toUpperCase()}'),
                      if (claim.status == ClaimStatus.accepted && claim.returnMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Return Instructions: ${claim.returnMessage}',
                              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: claim.status == ClaimStatus.pending
                      ? IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                          onPressed: () async {
                            await provider.updateClaimStatus(claim.id, ClaimStatus.cancelled);
                          },
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
