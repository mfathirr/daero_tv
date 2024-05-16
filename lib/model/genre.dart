import 'package:daero_tv/model/movie_genre.dart';

class Genre {
  List<MovieGenre> genres;

  Genre({
    required this.genres,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        genres: List<MovieGenre>.from(
            json["genres"].map((x) => MovieGenre.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}
