import 'package:flutter/material.dart';

import '../model/image.dart';
import '../services/api_service.dart';

enum ResultState { loading, noData, hasData, error }

class ImageProvider extends ChangeNotifier {
  final ApiService apiService;
  final int id;

  ImageProvider({required this.id, required this.apiService}) {
    fetchImageMovieById();
  }

  late ResultState _state;
  late ImageById _result;
  String _message = '';

  ResultState get state => _state;
  ImageById get result => _result;
  String get message => _message;

  Future<dynamic> fetchImageMovieById() async {
    try {
      _state = ResultState.loading;
      final imagesId = await apiService.fetchImageById(id);
      if (imagesId.id.toString().isEmpty) {
        _state = ResultState.noData;
        _message = 'Data is Empty';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = imagesId;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Failed to load data';
    }
  }
}
