import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';
import 'asset_detail_screen.dart';
import 'add_edit_asset_screen.dart';

class AssetsListScreen extends StatefulWidget {
  const AssetsListScreen({super.key});

  @override
  State<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListScreen> {
  List<Asset> _allAssets = [];
  List<Asset> _filteredAssets = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedCondition;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    setState(() => _isLoading = true);
    try {
      final assets = await context.read<SupabaseService>().getAssets();
      setState(() {
        _allAssets = assets;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredAssets = _allAssets.where((asset) {
        final matchesSearch = asset.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            asset.serialNumber.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == null || asset.categoryId == _selectedCategory;
        final matchesCondition = _selectedCondition == null || asset.condition == _selectedCondition;
        return matchesSearch && matchesCategory && matchesCondition;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditAssetScreen()),
            ).then((_) => _loadAssets()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search assets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: _showFilterDialog,
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAssets.isEmpty
                    ? const Center(child: Text('No assets found'))
                    : RefreshIndicator(
                        onRefresh: _loadAssets,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredAssets.length,
                          itemBuilder: (context, index) {
                            final asset = _filteredAssets[index];
                            return _buildAssetCard(asset);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(Asset asset) {
    Color statusColor;
    switch (asset.status) {
      case 'Available':
        statusColor = AppColors.secondary;
        break;
      case 'Assigned':
        statusColor = AppColors.accent;
        break;
      case 'Maintenance':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AssetDetailScreen(assetId: asset.id)),
        ).then((_) => _loadAssets()),
        title: Text(asset.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('SN: ${asset.serialNumber}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            asset.status ?? 'Unknown',
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Assets'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Categories')),
                      ..._allAssets
                          .map((a) => a.categoryId)
                          .toSet()
                          .map((id) => DropdownMenuItem(value: id, child: Text(id))) // In a real app, map to name
                    ],
                    onChanged: (value) => setDialogState(() => _selectedCategory = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    decoration: const InputDecoration(labelText: 'Condition'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Conditions')),
                      ...['New', 'Good', 'Fair', 'Poor']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    ],
                    onChanged: (value) => setDialogState(() => _selectedCondition = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _selectedCategory = null;
                      _selectedCondition = null;
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
