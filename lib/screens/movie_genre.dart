import 'package:daero_tv/providers/movie_by_genre.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieByGenre extends StatelessWidget {
  static const routeName = 'movie_genre_page';
  final int id;

  const MovieByGenre({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MovieByGenreProvider(apiService: ApiService(), id: id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Movie List"),
        ),
        body: Consumer<MovieByGenreProvider>(
          builder: (context, value, child) {
            if (value.state == ResultState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == ResultState.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.7),
                itemCount: value.result?.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500/${value.result?[index].posterPath}",
                          fit: BoxFit.cover,
                        )),
                  );
                },
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
