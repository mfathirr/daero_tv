import 'package:daero_tv/model/movie_detail.dart';
import 'package:daero_tv/providers/detail_movie.dart' as movie_detail;
import 'package:daero_tv/providers/image_movie_provider.dart' as image_provider;
import 'package:daero_tv/providers/movie_recommend_provider.dart'
    as movie_recommed;
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  static const routeName = 'detail_page';
  final String getImage = "https://image.tmdb.org/t/p/w500/";

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                image_provider.ImageProvider(id: id, apiService: ApiService()),
          ),
          ChangeNotifierProvider(
            create: (context) => movie_detail.MovieDetailProvider(
                apiService: ApiService(), id: id),
          ),
          ChangeNotifierProvider(
            create: (context) => movie_recommed.MovieRecommendProvider(
                id: id, apiService: ApiService()),
          )
        ],
        child: _buildDetailPage(),
      ),
    );
  }

  Consumer<movie_detail.MovieDetailProvider> _buildDetailPage() {
    return Consumer<movie_detail.MovieDetailProvider>(
      builder: (context, value, child) {
        if (value.state == movie_detail.ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == movie_detail.ResultState.hasData) {
          var detail = value.result;
          return CustomScrollView(
            slivers: [
              _buildAppBar(detail, context),
              _buildBodyDetail(detail, context)
            ],
          );
        } else {
          return Center(
            child: Text(value.message),
          );
        }
      },
    );
  }

  SliverToBoxAdapter _buildBodyDetail(Detail detail, BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Image.network(
              "$getImage${detail.backdropPath}",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child:
                    Image.network(width: 80, "$getImage${detail.posterPath}"),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.originalTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  detail.tagline,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                _buildListGenre(context, detail),
                Row(
                  children: [
                    Text(
                      detail.releaseDate.toString().substring(0, 10),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "${detail.runtime} minutes",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Overview",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  detail.overview,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Documentations",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                _buildImageMovie(),
                const SizedBox(
                  height: 6,
                ),
                // Text(
                //   "Production Companies",
                //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                //       fontWeight: FontWeight.w500, color: Colors.white),
                // ),
                // const SizedBox(
                //   height: 6,
                // ),
                // _buildListCompanies(detail),
                // const SizedBox(
                //   height: 6,
                // ),
                Text(
                  "Movie Recommendations",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                _buildMovieRecommend()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Consumer<movie_recommed.MovieRecommendProvider> _buildMovieRecommend() {
    return Consumer<movie_recommed.MovieRecommendProvider>(
      builder: (context, value, child) {
        if (value.state == movie_recommed.ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == movie_recommed.ResultState.hasData) {
          var recommend = value.result.movie;
          return SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommend.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, MovieDetailPage.routeName,
                          arguments: recommend[index].id),
                      child: Image.network(
                          "$getImage${recommend[index].posterPath}"),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text(value.message),
          );
        }
      },
    );
  }

  Consumer<image_provider.ImageProvider> _buildImageMovie() {
    return Consumer<image_provider.ImageProvider>(
      builder: (context, value, child) {
        if (value.state == image_provider.ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == image_provider.ResultState.hasData) {
          var image = value.result.backdrops;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: image.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Image.network("$getImage${image[index].filePath}"),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text(value.message),
          );
        }
      },
    );
  }

  SizedBox _buildListGenre(BuildContext context, Detail detail) {
    return SizedBox(
      height: 30,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detail.genres.length,
        itemBuilder: (context, index) {
          return Center(
              child: Text(
            detail.genres[index].name,
            style: const TextStyle(color: Color(0xFFCAC4C4)),
          ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const VerticalDivider(
            indent: 5,
            endIndent: 5,
            color: Color(0xFFCAC4C4),
          );
        },
      ),
    );
  }

  SizedBox _buildListCompanies(Detail detail) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: detail.productionCompanies.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: detail.productionCompanies[index].logoPath != null
                ? Image.network(
                    width: 100,
                    "$getImage${detail.productionCompanies[index].logoPath}")
                : const SizedBox(),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 16,
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(Detail value, BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: Text(
        value.title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFF222222),
      surfaceTintColor: const Color(0xFF222222),
    );
  }
}
