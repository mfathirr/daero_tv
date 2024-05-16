import 'dart:convert';
import 'package:daero_tv/model/film.dart';
import 'package:daero_tv/model/genre.dart';
import 'package:daero_tv/model/movie_detail.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = "https://api.themoviedb.org/3/movie";
const String _apiKey = "?api_key=1194456987593407c4b868bb4bcb6330";

class ApiService {
  Future<Film> fetchPopularMovie() async {
    const String popular = '/popular';

    const String url = "$_baseUrl$popular$_apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<Film> fetchTopRatedMovie() async {
    const String topRated = '/top_rated';

    const String url = "$_baseUrl$topRated$_apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<Detail> fetchDetailMovie(int id) async {
    String url = "$_baseUrl/$id$_apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Detail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<Genre> fetchGenreMovie() async {
    String query = "language=en";
    String url = "https://api.themoviedb.org/3/genre/movie/list$_apiKey&$query";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Genre.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<Film> fetchMovieByGenre(int id) async {
    String withGenres = "with_genres=$id";
    String url =
        "https://api.themoviedb.org/3/discover/movie$_apiKey&$withGenres";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("berhasil");
      return Film.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
