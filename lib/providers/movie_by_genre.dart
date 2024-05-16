import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';

import '../model/movie.dart';

enum ResultState { loading, noData, hasData, error }

class MovieByGenreProvider extends ChangeNotifier {
  final ApiService apiService;
  final int id;

  MovieByGenreProvider({required this.apiService, required this.id}) {
    fetchMovieByGenre();
  }

  List<Movie>? _result;
  late ResultState _state;
  String _message = '';

  ResultState get state => _state;
  List<Movie>? get result => _result;
  String get message => _message;

  Future<dynamic> fetchMovieByGenre() async {
    try {
      _state = ResultState.loading;
      final movie = await apiService.fetchMovieByGenre(id);
      if (movie.movie.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
        print('not');
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        print('success');
        return _result = movie.movie;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
