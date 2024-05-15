import 'package:daero_tv/providers/top_rated_movie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedMovies extends StatelessWidget {
  static const routeName = '/top_rated_page';
  final String imagePath;

  const TopRatedMovies({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Top Movie"),
      ),
      body: Consumer<MovieTopRatedProvider>(
        builder:
            (BuildContext context, MovieTopRatedProvider value, Widget? child) {
          return GridView.builder(
            itemCount: value.result?.length,
            itemBuilder: (context, index) {
              return Card(
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Image.network(
                      "$imagePath${value.result?[index].posterPath}",
                      fit: BoxFit.cover,
                    )),
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
