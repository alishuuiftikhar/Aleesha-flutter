import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/idea_provider.dart';
import '../../widgets/idea_card.dart';
import '../../widgets/common/empty_state.dart';

class IdeasListScreen extends StatefulWidget {
  const IdeasListScreen({super.key});

  @override
  State<IdeasListScreen> createState() => _IdeasListScreenState();
}

class _IdeasListScreenState extends State<IdeasListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<IdeaProvider>().load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IdeaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Project Ideas Studio'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search ideas by title or keyword',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: provider.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.setQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: provider.setQuery,
            ),
          ),
          SizedBox(
            height: 42,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                _FilterDropdown(
                  value: provider.domain,
                  items: ['All Domains', ...AppConstants.domains],
                  onChanged: provider.setDomain,
                ),
                const SizedBox(width: 8),
                _FilterDropdown(
                  value: provider.supervisor,
                  items: ['All Supervisors', ...provider.supervisorNames],
                  onChanged: provider.setSupervisor,
                ),
                const SizedBox(width: 8),
                ActionChip(
                  label: const Text('Reset'),
                  onPressed: () {
                    _searchController.clear();
                    provider.resetFilters();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.ideas.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No ideas found',
                        message: 'Try adjusting your search or filters.',
                      )
                    : RefreshIndicator(
                        onRefresh: provider.load,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          itemCount: provider.ideas.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final idea = provider.ideas[index];
                            return IdeaCard(
                              idea: idea,
                              onTap: () => Navigator.of(context)
                                  .pushNamed(AppRoutes.ideaDetail, arguments: idea),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12.5)))).toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}
