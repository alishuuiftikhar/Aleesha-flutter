import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/tutor_model.dart';
import '../booking/booking_screen.dart';

class TutorProfileScreen extends StatefulWidget {
  final String tutorId;
  const TutorProfileScreen({super.key, required this.tutorId});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  TutorModel? _tutor;
  bool _isLoading = true;

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadTutor();
    _checkFavorite();
  }

  void _checkFavorite() async {
    final service = context.read<SupabaseService>();
    final user = service.currentUser;
    if (user != null) {
      final favs = await service.getFavoriteTutorIds(user.id);
      if (mounted) {
        setState(() {
          _isFavorite = favs.contains(widget.tutorId);
        });
      }
    }
  }

  void _toggleFavorite() async {
    final service = context.read<SupabaseService>();
    final user = service.currentUser;
    if (user == null) return;

    setState(() => _isFavorite = !_isFavorite);
    try {
      await service.toggleFavorite(user.id, widget.tutorId, _isFavorite);
    } catch (e) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  void _loadTutor() async {
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      final tutor = await service.getTutorById(widget.tutorId);
      if (mounted) {
        setState(() {
          _tutor = tutor;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Tutor Profile Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_tutor == null) return const Scaffold(body: Center(child: Text('Tutor not found')));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                onPressed: _toggleFavorite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _tutor!.avatarUrl != null
                  ? Image.network(
                      _tutor!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.secondaryBackground,
                        child: const Icon(Icons.person, size: 100, color: AppColors.primary),
                      ),
                    )
                  : Container(
                      color: AppColors.secondaryBackground,
                      child: const Icon(Icons.person, size: 100, color: AppColors.primary),
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tutor!.fullName ?? 'Tutor Name',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _tutor!.subjects.map((e) => e.name).join(', '),
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '\$${_tutor!.hourlyRate}/hr',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('About', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(_tutor!.bio),
                const SizedBox(height: 24),
                const Text('Experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(_tutor!.experience),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingScreen(tutor: _tutor!)),
            );
          },
          child: const Text('Book a Class'),
        ),
      ),
    );
  }
}
