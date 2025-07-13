class Anime {
  final String id;
  final String name;
  final String type;
  final double rate;
  final String emotionTag;

  Anime({
    required this.id,
    required this.name,
    required this.type,
    required this.rate,
    required this.emotionTag,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'].toString(),
      name: json['anime'],
      type: json['genere'],
      rate: (json['rate'] as num).toDouble(),
      emotionTag: json['emotion_tag'] ?? '',
    );
  }
}
