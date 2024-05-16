import 'package:daero_tv/model/genre.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class GenreProvider extends ChangeNotifier {
  final ApiService apiService;

  GenreProvider({required this.apiService}) {
    fetchGenreMovie();
  }

  late ResultState _state;
  late Genre _result;
  String _message = '';

  ResultState get state => _state;
  Genre get result => _result;
  String get message => _message;

  Future<dynamic> fetchGenreMovie() async {
    try {
      _state = ResultState.loading;
      final genres = await apiService.fetchGenreMovie();
      if (genres.genres.isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = genres;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
