import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final _appState = AppState();

  final List<Map<String, dynamic>> posts = [
    {
      'user': 'Chef Marco',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      'caption': 'Just finished making the best salad ever! #HealthyEating',
      'likes': 245,
      'comments': 12
    },
    {
      'user': 'Linda J.',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=800&q=80',
      'caption': 'Pizza night with the kids! 🍕 used the Margherita recipe from Chef Hat.',
      'likes': 512,
      'comments': 45
    },
    {
      'user': 'John Cook',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=800&q=80',
      'caption': 'Tikka Masala turned out great. Highly recommend adding extra ginger.',
      'likes': 128,
      'comments': 8
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSoftWhite,
      appBar: AppBar(
        title: const Text('Chef Community'),
        actions: [IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: posts.length,
        itemBuilder: (ctx, index) {
          final post = posts[index];
          final bool isLiked = _appState.likedPostIndexes.contains(index);
          final int displayLikes = isLiked ? post['likes'] + 1 : post['likes'];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: AppTheme.softShadow),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(post['avatar']!)),
                  title: Text(post['user']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: const Text('2 hours ago', style: TextStyle(fontSize: 12)),
                  trailing: IconButton(icon: const Icon(Icons.more_horiz_rounded), onPressed: () {}),
                ),
                GestureDetector(
                  onDoubleTap: () => setState(() => _appState.likedPostIndexes.add(index)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.network(post['image']!, width: double.infinity, height: 350, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: isLiked ? Colors.red : AppTheme.textDark),
                            onPressed: () => setState(() => isLiked ? _appState.likedPostIndexes.remove(index) : _appState.likedPostIndexes.add(index)),
                          ),
                          Text('$displayLikes', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.textDark),
                          const SizedBox(width: 8),
                          Text('${post['comments']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          const Icon(Icons.bookmark_border_rounded),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
                          children: [
                            TextSpan(text: '${post['user']} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: post['caption']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryNavy,
        onPressed: () {},
        child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
      ),
    );
  }
}
