import 'package:carousel_slider/carousel_slider.dart';
import 'package:daero_tv/providers/popular_movie.dart' as popular;
import 'package:daero_tv/providers/top_rated_movie.dart' as top_rated;
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
          return SizedBox(
            height: 225,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: Stack(alignment: Alignment.center, children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        child: Image.network(
                            "$getImage${topRated?[index].posterPath}")),
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
          return SizedBox(
            height: 225,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Image.network(
                          "$getImage${popular?[index].posterPath}")),
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
