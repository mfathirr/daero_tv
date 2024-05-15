import 'movie.dart';

class Film {
  int page;
  List<Movie> movie;
  int totalPages;
  int totalResults;

  Film({
    required this.page,
    required this.movie,
    required this.totalPages,
    required this.totalResults,
  });

  factory Film.fromJson(Map<String, dynamic> json) => Film(
        page: json["page"],
        movie: List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(movie.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
