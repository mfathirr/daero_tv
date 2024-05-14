import 'movie.dart';

class Populer {
  int page;
  List<Movie> movie;
  int totalPages;
  int totalResults;

  Populer({
    required this.page,
    required this.movie,
    required this.totalPages,
    required this.totalResults,
  });

  factory Populer.fromJson(Map<String, dynamic> json) => Populer(
        page: json["page"],
        movie:
            List<Movie>.from(json["results"].map((x) => Movie.fromJson(x))),
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
