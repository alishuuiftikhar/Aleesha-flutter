import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchAndFilterWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedTimeframe;
  final ValueChanged<String> onTimeframeChanged;
  final List<String> timeframes;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final List<String> statuses;

  const SearchAndFilterWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
    this.timeframes = const ['All', 'Today', 'This Week'],
    required this.selectedStatus,
    required this.onStatusChanged,
    this.statuses = const ['All'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search TextField
        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search records...',
            prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                    onPressed: () {
                      searchController.clear();
                      onSearchChanged('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        // Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text('Time: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13)),
              ...timeframes.map((tf) {
                final isSelected = selectedTimeframe == tf;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(tf),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onTimeframeChanged(tf);
                    },
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
              if (statuses.length > 1) ...[
                const SizedBox(width: 8),
                const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 13)),
                ...statuses.map((st) {
                  final isSelected = selectedStatus == st;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: ChoiceChip(
                      label: Text(st),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) onStatusChanged(st);
                      },
                      selectedColor: AppTheme.accent,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
