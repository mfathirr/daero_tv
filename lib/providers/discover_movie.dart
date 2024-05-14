import 'package:daero_tv/model/movie.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class MovieProvider extends ChangeNotifier {
  final ApiService apiService;

  MovieProvider({required this.apiService}) {}

  late ResultState _state;
  late List<Movie> _result;
  String _message = '';

  ResultState get state => _state;
  List<Movie> get result => _result;
  String get message => _message;

  Future<dynamic> fetchDiscoverMovie() async {
    try {
      _state = ResultState.loading;
      final movie = await apiService.fetchMovie();
      if (movie.movie.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = movie.movie;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
