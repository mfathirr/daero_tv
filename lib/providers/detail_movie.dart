import 'package:daero_tv/model/movie_detail.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class MovieDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final int id;

  MovieDetailProvider({required this.apiService, required this.id}) {
    fetchDetailMovie();
  }

  late Detail _detail;
  late ResultState _state;
  String _message = '';

  ResultState get state => _state;
  Detail get result => _detail;
  String get message => _message;

  Future<dynamic> fetchDetailMovie() async {
    try {
      _state = ResultState.loading;
      final movie = await apiService.fetchDetailMovie(id);
      if (movie.id.toString().isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detail = movie;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
