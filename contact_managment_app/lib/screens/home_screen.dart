import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contact_model.dart';
import '../models/group_model.dart';
import '../theme/app_theme.dart';
import 'add_edit_contact_screen.dart';
import 'contact_detail_screen.dart';
import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ContactModel> _contacts = [];
  List<ContactModel> _favorites = [];
  List<GroupModel> _groups = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _sortBy = 'name_asc';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    final contacts = await DatabaseHelper.instance.readAllContacts(
      query: _searchQuery,
      sortBy: _sortBy,
    );
    final favorites = await DatabaseHelper.instance.readFavorites();
    final groups = await DatabaseHelper.instance.readAllGroups();
    
    setState(() {
      _contacts = contacts;
      _favorites = favorites;
      _groups = groups;
      _isLoading = false;
    });
  }

  Map<String, List<ContactModel>> _groupContactsAlphabetically(List<ContactModel> contacts) {
    Map<String, List<ContactModel>> grouped = {};
    for (var contact in contacts) {
      String firstLetter = contact.name.isEmpty ? '#' : contact.name[0].toUpperCase();
      if (!RegExp(r'[A-Z]').hasMatch(firstLetter)) {
        firstLetter = '#';
      }
      if (grouped[firstLetter] == null) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(contact);
    }
    return Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.plum,
          unselectedLabelColor: AppTheme.textGrey,
          indicatorColor: AppTheme.coralPink,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Groups'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _refreshData();
              },
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.plum),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContactList(_contacts),
                _buildContactList(_favorites),
                _buildGroupsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditContactScreen()),
          );
          _refreshData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContactList(List<ContactModel> contacts) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contacts.isEmpty) {
      return const Center(child: Text('No contacts found'));
    }

    final grouped = _groupContactsAlphabetically(contacts);
    final keys = grouped.keys.toList();

    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final letter = keys[index];
        final letterContacts = grouped[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.plum,
                ),
              ),
            ),
            ...letterContacts.map((contact) => _buildContactTile(contact)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildContactTile(ContactModel contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.coralPink.withOpacity(0.2),
        child: Text(
          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
          style: const TextStyle(color: AppTheme.plum, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(contact.name),
      subtitle: Text(contact.phoneNumber),
      trailing: contact.isFavorite == 1
          ? const Icon(Icons.favorite, color: AppTheme.coralPink)
          : null,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactDetailScreen(contact: contact),
          ),
        );
        _refreshData();
      },
    );
  }

  Widget _buildGroupsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.group_add, color: AppTheme.plum),
          title: const Text('Manage Groups'),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const GroupsScreen()),
            );
            _refreshData();
          },
        ),
        const Divider(),
        Expanded(
          child: _groups.isEmpty
              ? const Center(child: Text('No groups created'))
              : ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    return ListTile(
                      leading: const Icon(Icons.folder, color: AppTheme.coralPink),
                      title: Text(group.name),
                      onTap: () {
                        _showGroupContacts(group);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showGroupContacts(GroupModel group) async {
    final contacts = await DatabaseHelper.instance.readContactsByGroup(group.id!);
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Contacts in ${group.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.plum),
            ),
          ),
          const Divider(),
          Expanded(
            child: contacts.isEmpty
                ? const Center(child: Text('No contacts in this group'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) => _buildContactTile(contacts[index]),
                  ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Name (A-Z)'),
              leading: Radio<String>(
                value: 'name_asc',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                  _refreshData();
                },
              ),
            ),
            ListTile(
              title: const Text('Name (Z-A)'),
              leading: Radio<String>(
                value: 'name_desc',
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() => _sortBy = value!);
                  Navigator.pop(context);
                  _refreshData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
