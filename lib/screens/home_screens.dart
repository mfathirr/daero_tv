import 'package:daero_tv/providers/popular_movie.dart' as popular;
import 'package:daero_tv/providers/top_rated_movie.dart' as topRated;
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
          body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Popular',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            _buildDiscoverMovie(),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Top Rated',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Consumer<topRated.MovieTopRatedProvider>(
              builder: (context, value, child) {
                if (value.state == topRated.ResultState.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (value.state == topRated.ResultState.hasData) {
                  var topRated = value.result;
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
                                    const BorderRadius.all(Radius.circular(4)),
                                child: Image.network(
                                    "$getImage${topRated[index].posterPath}")),
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
            )
          ],
        ),
      )),
    );
  }

  Consumer<popular.MoviePopularProvider> _buildDiscoverMovie() {
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
            height: 255,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: value.result.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Stack(alignment: Alignment.center, children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        child: Image.network(
                            "$getImage${popular[index].posterPath}")),
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
