class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String genre;
  final String rating;
  final String description;
  final String releaseYear;
  final String duration;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.rating,
    required this.description,
    required this.releaseYear,
    required this.duration,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String? posterPath = json['poster_path'] ?? json['backdrop_path'];
    // High-resolution posters from TMDB
    String imgUrl = posterPath != null 
        ? 'https://image.tmdb.org/t/p/w780$posterPath' 
        : 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=500&auto=format&fit=crop';

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Untitled',
      imageUrl: imgUrl,
      genre: '', 
      rating: (json['vote_average'] as num?)?.toStringAsFixed(1) ?? '8.2',
      description: json['overview'] ?? 'Explore this cinematic masterpiece exclusively on CinePulse.',
      releaseYear: (json['release_date'] ?? json['first_air_date'] ?? '2024').toString().split('-')[0],
      duration: '2h 15m',
    );
  }
}
