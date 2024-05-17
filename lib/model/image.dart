import 'backdrop.dart';

class ImageById {
  List<Backdrop> backdrops;
  int id;
  List<Backdrop> logos;
  List<Backdrop> posters;

  ImageById({
    required this.backdrops,
    required this.id,
    required this.logos,
    required this.posters,
  });

  factory ImageById.fromJson(Map<String, dynamic> json) => ImageById(
        backdrops: List<Backdrop>.from(
            json["backdrops"].map((x) => Backdrop.fromJson(x))),
        id: json["id"],
        logos:
            List<Backdrop>.from(json["logos"].map((x) => Backdrop.fromJson(x))),
        posters: List<Backdrop>.from(
            json["posters"].map((x) => Backdrop.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "backdrops": List<dynamic>.from(backdrops.map((x) => x.toJson())),
        "id": id,
        "logos": List<dynamic>.from(logos.map((x) => x.toJson())),
        "posters": List<dynamic>.from(posters.map((x) => x.toJson())),
      };
}
