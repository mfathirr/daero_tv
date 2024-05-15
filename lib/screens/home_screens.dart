import 'package:daero_tv/providers/discover_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  final String getImage = "https://image.tmdb.org/t/p/w500/";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          _buildDiscoverMovie(),
        ],
      )),
    );
  }

  Consumer<MovieProvider> _buildDiscoverMovie() {
    return Consumer<MovieProvider>(
      builder: (BuildContext context, MovieProvider value, Widget? child) {
        if (value.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == ResultState.hasData) {
          var movie = value.result;
          return SizedBox(
            height: 255,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: value.result.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Stack(alignment: Alignment.center, children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                            "$getImage${movie[index].posterPath}")),
                    // Text(movie[index].title)
                  ]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 8,
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
    );
  }
}
