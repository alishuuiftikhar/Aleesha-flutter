import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'theme.dart';
import 'models.dart';
import 'app_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const InspirationApp(),
    ),
  );
}

class InspirationApp extends StatelessWidget {
  const InspirationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design Inspiration',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

// --- Screens ---

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette_outlined, size: 100, color: AppColors.accent),
            const SizedBox(height: 24),
            Text(
              'CREATIVE',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            Text(
              'INSPIRATION',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.secondaryBackground,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 48),
            const SpinKitThreeBounce(
              color: AppColors.accent,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MoodboardsScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.primary.withOpacity(0.4),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize), label: 'Boards'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";
  final List<String> _categories = [
    "All",
    "Graphic design",
    "Interior design",
    "Fashion",
    "Photography",
    "UI design",
    "Color palettes"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final filteredInspirations = provider.allInspirations.where((i) {
      final matchesSearch = i.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          i.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == "All" || i.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Explore', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: InspirationSearchDelegate(provider.allInspirations));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = category);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.secondaryBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),
          // Masonry Grid
          Expanded(
            child: provider.isLoading
                ? const Center(child: SpinKitFadingCube(color: AppColors.primary))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: filteredInspirations.length,
                      itemBuilder: (context, index) {
                        return InspirationCard(inspiration: filteredInspirations[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class InspirationCard extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationCard({super.key, required this.inspiration});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(inspiration: inspiration)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Hero(
                tag: inspiration.id,
                child: CachedNetworkImage(
                  imageUrl: inspiration.imageUrl,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: AppColors.secondaryBackground,
                    child: const Center(child: SpinKitPulse(color: AppColors.primary)),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inspiration.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    inspiration.author,
                    style: TextStyle(color: AppColors.text.withOpacity(0.6), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Inspiration inspiration;
  const DetailScreen({super.key, required this.inspiration});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isFav = provider.isFavorite(inspiration.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenViewer(imageUrl: inspiration.imageUrl),
                  ),
                ),
                child: Hero(
                  tag: inspiration.id,
                  child: CachedNetworkImage(
                    imageUrl: inspiration.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white),
                onPressed: () => provider.toggleFavorite(inspiration.id),
              ),
              IconButton(
                icon: const Icon(Icons.add_to_photos, color: Colors.white),
                onPressed: () => _showAddToMoodboardDialog(context, provider),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inspiration.category,
                              style: TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              inspiration.title,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "by ${inspiration.author}",
                    style: TextStyle(color: AppColors.text.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    inspiration.description,
                    style: const TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Color Palette",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: inspiration.palette.length,
                      itemBuilder: (context, index) {
                        final colorHex = inspiration.palette[index];
                        final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              colorHex,
                              style: TextStyle(
                                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Notes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  _NotesSection(inspirationId: inspiration.id),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToMoodboardDialog(BuildContext context, AppProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add to Moodboard", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (provider.moodboards.isEmpty)
                const Text("No moodboards yet. Create one in the Boards tab.")
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.moodboards.length,
                    itemBuilder: (context, index) {
                      final mb = provider.moodboards[index];
                      final contains = mb.inspirationIds.contains(inspiration.id);
                      return ListTile(
                        title: Text(mb.name),
                        trailing: Icon(contains ? Icons.check_circle : Icons.add_circle_outline, 
                          color: contains ? Colors.green : AppColors.primary),
                        onTap: () {
                          if (!contains) {
                            provider.addToMoodboard(mb.id, inspiration.id);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Added to ${mb.name}")),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _NotesSection extends StatefulWidget {
  final String inspirationId;
  const _NotesSection({required this.inspirationId});

  @override
  State<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<_NotesSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final notes = provider.getNotesForInspiration(widget.inspirationId);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(note.content),
                subtitle: Text(DateFormat.yMMMd().add_jm().format(note.createdAt)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => provider.deleteNote(note.id),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Add a note...",
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: AppColors.primary),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  provider.addNote(widget.inspirationId, _controller.text);
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: AppColors.white,
          ),
        ),
      ],
    );
  }
}

class FullScreenViewer extends StatelessWidget {
  final String imageUrl;
  const FullScreenViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class MoodboardsScreen extends StatelessWidget {
  const MoodboardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Moodboards', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: provider.moodboards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.dashboard_customize_outlined, size: 80, color: AppColors.secondaryBackground),
                  const SizedBox(height: 16),
                  const Text("No moodboards yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateBoardDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text("Create First Board"),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: provider.moodboards.length,
              itemBuilder: (context, index) {
                final mb = provider.moodboards[index];
                final items = provider.getInspirationsForMoodboard(mb.id);
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MoodboardDetailScreen(moodboard: mb)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: items.isEmpty
                                ? Container(color: AppColors.secondaryBackground, child: const Icon(Icons.image_outlined))
                                : CachedNetworkImage(imageUrl: items.first.imageUrl, fit: BoxFit.cover, width: double.infinity),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mb.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${mb.inspirationIds.length} items", style: TextStyle(fontSize: 12, color: AppColors.text.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showCreateBoardDialog(context, provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateBoardDialog(BuildContext context, AppProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Moodboard"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter board name"),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.createMoodboard(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}

class MoodboardDetailScreen extends StatelessWidget {
  final Moodboard moodboard;
  const MoodboardDetailScreen({super.key, required this.moodboard});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final items = provider.getInspirationsForMoodboard(moodboard.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(moodboard.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showRenameDialog(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirm(context, provider),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text("This board is empty"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final inspiration = items[index];
                  return Stack(
                    children: [
                      InspirationCard(inspiration: inspiration),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          radius: 16,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Colors.red),
                            onPressed: () => provider.removeFromMoodboard(moodboard.id, inspiration.id),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  void _showRenameDialog(BuildContext context, AppProvider provider) {
    final controller = TextEditingController(text: moodboard.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Moodboard"),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter board name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              provider.renameMoodboard(moodboard.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Moodboard?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteMoodboard(moodboard.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to list
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final favorites = provider.favoriteInspirations;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Inspiration', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 80, color: AppColors.secondaryBackground),
                  const SizedBox(height: 16),
                  const Text("Nothing saved yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return InspirationCard(inspiration: favorites[index]);
                },
              ),
            ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.secondaryBackground,
            child: Icon(Icons.person, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text("Creative Designer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),
          _buildSettingTile(Icons.notifications_outlined, "Notifications", () {}),
          _buildSettingTile(Icons.lock_outline, "Privacy", () {}),
          _buildSettingTile(Icons.storage_outlined, "Storage Management", () {}),
          _buildSettingTile(Icons.help_outline, "Help & Support", () {}),
          _buildSettingTile(Icons.info_outline, "About", () {}),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

class InspirationSearchDelegate extends SearchDelegate {
  final List<Inspiration> inspirations;
  InspirationSearchDelegate(this.inspirations);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    final results = inspirations.where((i) => i.title.toLowerCase().contains(query.toLowerCase()) || i.category.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(item.title),
          subtitle: Text(item.category),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(inspiration: item)));
          },
        );
      },
    );
  }
}
