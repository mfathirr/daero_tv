import 'package:daero_tv/providers/popular_movie.dart';
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
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: const Color(0xFF222222),
        centerTitle: true,
        title: const Text(
          "Most Popular",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<MoviePopularProvider>(
        builder:
            (BuildContext context, MoviePopularProvider value, Widget? child) {
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
