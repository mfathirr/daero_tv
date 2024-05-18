import 'package:daero_tv/providers/movie_by_genre.dart';
import 'package:daero_tv/screens/movie_detail.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/movie_genre.dart';

class MovieByGenre extends StatelessWidget {
  static const routeName = 'movie_genre_page';
  final MovieGenre genre;

  const MovieByGenre({
    super.key,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MovieByGenreProvider(apiService: ApiService(), id: genre.id),
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
          title: Text(
            genre.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<MovieByGenreProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == ResultState.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 0.7),
                  itemCount: value.result?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, MovieDetailPage.routeName,
                            arguments: value.result?[index].id);
                      },
                      child: Card(
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w500/${value.result?[index].posterPath}",
                              fit: BoxFit.cover,
                            )),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Material(
                  child: Text(value.message),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
