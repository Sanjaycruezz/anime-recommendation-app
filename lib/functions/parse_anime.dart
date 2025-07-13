
import '../models/anime_model.dart';

List<Anime> parse_anime(List<dynamic> jsonData) {
  return jsonData.map((animeJson) => Anime.fromJson(animeJson)).toList();
}
