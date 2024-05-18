import 'package:daero_tv/model/film.dart';
import 'package:flutter/cupertino.dart';

import '../services/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class MovieRecommendProvider extends ChangeNotifier {
  final ApiService apiService;
  final int id;

  MovieRecommendProvider({required this.id, required this.apiService}) {
    fetchMovieRecommend();
  }

  late ResultState _state;
  late Film _result;
  String _message = '';

  ResultState get state => _state;
  Film get result => _result;
  String get message => _message;

  Future<dynamic> fetchMovieRecommend() async {
    try {
      _state = ResultState.loading;
      final recommend = await apiService.fetchMovieRecommendations(id);
      if (recommend.movie.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = recommend;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
