import 'package:daero_tv/providers/popular_movie.dart';
import 'package:daero_tv/screens/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMovies extends StatelessWidget {
  static const routeName = '/popular_page';
  final String imagePath;
  const PopularMovies({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Most Popular"),
      ),
      body: Consumer<MoviePopularProvider>(
        builder:
            (BuildContext context, MoviePopularProvider value, Widget? child) {
          return GridView.builder(
            itemCount: value.result?.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, MovieDetailPage.routeName);
                  },
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Image.network(
                        "$imagePath${value.result?[index].posterPath}",
                        fit: BoxFit.cover,
                      )),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.7),
          );
        },
      ),
    ));
  }
}
