import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../services/supabase_service.dart';
import '../../models/tutor_model.dart';
import '../../models/subject_model.dart';
import '../tutor/tutor_profile_screen.dart';
import '../tutor/add_guest_tutor_screen.dart';

class TutorListView extends StatefulWidget {
  const TutorListView({super.key});

  @override
  State<TutorListView> createState() => _TutorListViewState();
}

class _TutorListViewState extends State<TutorListView> {
  List<TutorModel> _tutors = [];
  List<SubjectModel> _subjects = [];
  bool _isLoading = true;
  int? _selectedSubjectId;
  final TextEditingController _searchController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final service = context.read<SupabaseService>();
      final tutors = await service.getTutors();
      final subjects = await service.getSubjects();
      if (mounted) {
        setState(() {
          _tutors = tutors;
          _subjects = subjects;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Tutor List Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  List<TutorModel> get _filteredTutors {
    return _tutors.where((tutor) {
      final matchesQuery = _searchController.text.isEmpty ||
          (tutor.fullName?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false);
      final matchesSubject = _selectedSubjectId == null || tutor.subjects.any((s) => s.id == _selectedSubjectId);
      return matchesQuery && matchesSubject;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    final filteredList = _filteredTutors;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGuestTutorScreen()),
          ).then((_) => _loadData());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Find a Tutor'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search tutors...',
                        prefixIcon: const Icon(Icons.search),
                        fillColor: AppColors.secondaryBackground,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _subjects.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: const Text('All'),
                                selected: _selectedSubjectId == null,
                                onSelected: (_) => setState(() => _selectedSubjectId = null),
                              ),
                            );
                          }
                          final subject = _subjects[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(subject.name),
                              selected: _selectedSubjectId == subject.id,
                              onSelected: (selected) {
                                setState(() => _selectedSubjectId = selected ? subject.id : null);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Want to Teach?',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Join our community of expert tutors and start earning today.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Profile to switch mode
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Go to Profile to Register as a Tutor!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(120, 36),
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
          if (filteredList.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No tutors found matching your criteria.'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tutor = filteredList[index];
                    return _buildTutorCard(tutor);
                  },
                  childCount: filteredList.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTutorCard(TutorModel tutor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorProfileScreen(tutorId: tutor.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.secondaryBackground,
                backgroundImage: tutor.avatarUrl != null ? NetworkImage(tutor.avatarUrl!) : null,
                child: tutor.avatarUrl == null ? const Icon(Icons.person, size: 40, color: AppColors.primary) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.fullName ?? 'Tutor Name',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tutor.subjects.map((e) => e.name).join(', '),
                      style: TextStyle(color: AppColors.text.withOpacity(0.7)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${tutor.rating} (${tutor.totalReviews} reviews)'),
                        const Spacer(),
                        Text(
                          '\$${tutor.hourlyRate.toStringAsFixed(2)}/hr',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
