import 'package:carousel_slider/carousel_slider.dart';
import 'package:daero_tv/model/movie.dart';
import 'package:daero_tv/providers/genre_movie.dart';
import 'package:daero_tv/providers/popular_movie.dart' as popular;
import 'package:daero_tv/providers/top_rated_movie.dart' as top_rated;
import 'package:daero_tv/screens/movie_detail.dart';
import 'package:daero_tv/screens/movie_genre.dart';
import 'package:daero_tv/screens/popular_movies.dart';
import 'package:daero_tv/screens/top_rated_movies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';
  final String getImage = "https://image.tmdb.org/t/p/w500/";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Daero TV'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCarousel(),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Categories",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildGenreList(),
                const SizedBox(
                  height: 12,
                ),
                _buildTextIconArrow(
                    "Popular Movie", context, PopularMovies.routeName),
                const SizedBox(
                  height: 12,
                ),
                _buildPopularMovie(),
                const SizedBox(
                  height: 12,
                ),
                _buildTextIconArrow(
                    "Top-Rated Movie", context, TopRatedMovies.routeName),
                _buildTopRatedMovie()
              ],
            ),
          )),
    );
  }

  Consumer<GenreProvider> _buildGenreList() {
    return Consumer<GenreProvider>(
      builder: (context, value, child) {
        if (value.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == ResultState.hasData) {
          var genres = value.result.genres;
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.result.genres.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MovieByGenre.routeName,
                          arguments: genres[index]);
                    },
                    child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(genres[index].name),
                        ))),
                  );
                },
              ),
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

  Consumer<popular.MoviePopularProvider> _buildCarousel() {
    return Consumer<popular.MoviePopularProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CarouselSlider.builder(
            options: CarouselOptions(
                viewportFraction: 1,
                initialPage: 0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                enlargeFactor: 0.5),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return SizedBox(
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Image.network(
                        "$getImage${value.result?[index].backdropPath}"),
                  ),
                ]),
              );
            },
          ),
        );
      },
    );
  }

  Padding _buildTextIconArrow(String text, BuildContext context, route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
              padding: EdgeInsets.zero,
              // constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pushNamed(context, route, arguments: getImage);
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded))
        ],
      ),
    );
  }

  Consumer<top_rated.MovieTopRatedProvider> _buildTopRatedMovie() {
    return Consumer<top_rated.MovieTopRatedProvider>(
      builder: (context, value, child) {
        if (value.state == top_rated.ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == top_rated.ResultState.hasData) {
          var topRated = value.result;
          return _cardImage(topRated);
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

  Consumer<popular.MoviePopularProvider> _buildPopularMovie() {
    return Consumer<popular.MoviePopularProvider>(
      builder: (BuildContext context, popular.MoviePopularProvider value,
          Widget? child) {
        if (value.state == popular.ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == popular.ResultState.hasData) {
          var popular = value.result;
          return _cardImage(popular);
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

  Padding _cardImage(List<Movie>? movie) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(
        height: 225,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, MovieDetailPage.routeName,
                    arguments: movie?[index].id);
              },
              child: Card(
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child:
                        Image.network("$getImage${movie?[index].posterPath}")),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 8,
            );
          },
        ),
      ),
    );
  }
}
