import 'movie.dart';

class Discover {
  int page;
  List<Movie> movie;
  int totalPages;
  int totalResults;

  Discover({
    required this.page,
    required this.movie,
    required this.totalPages,
    required this.totalResults,
  });

  factory Discover.fromJson(Map<String, dynamic> json) => Discover(
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

