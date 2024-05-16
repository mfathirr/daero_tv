import 'package:daero_tv/model/movie_detail.dart';
import 'package:daero_tv/providers/detail_movie.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = 'detail_page';
  final String getImage = "https://image.tmdb.org/t/p/w500/";

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) =>
            MovieDetailProvider(apiService: ApiService(), id: id),
        child: Consumer<MovieDetailProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == ResultState.hasData) {
              var detail = value.result;
              return CustomScrollView(
                slivers: [
                  _buildAppBar(detail),
                ],
              );
            } else {
              return Center(
                child: Text(value.message),
              );
            }
          },
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(Detail value) {
    return SliverAppBar(
      centerTitle: true,
      title: Text(value.title),
    );
  }
}
