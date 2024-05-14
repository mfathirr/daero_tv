import 'dart:convert';

import 'package:daero_tv/model/movie_discover.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = "https://api.themoviedb.org/3";
const String _movie = "/movie";

class ApiService {
  static const String _list = '/discover';

  Future<Discover> fetchMovie() async {
    const String url = "$_baseUrl$_list$_movie";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Discover.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }
}
