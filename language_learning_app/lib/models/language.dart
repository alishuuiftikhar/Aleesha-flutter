class Language {
  final String id;
  final String name;
  final String flag;

  Language({required this.id, required this.name, required this.flag});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name'],
      flag: json['flag'],
    );
  }
}
