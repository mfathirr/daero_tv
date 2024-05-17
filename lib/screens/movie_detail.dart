import 'package:daero_tv/model/movie_detail.dart';
import 'package:daero_tv/providers/detail_movie.dart';
import 'package:daero_tv/providers/image_movie_provider.dart' as image_provider;
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/cupertino.dart';
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
            create: (context) =>
                MovieDetailProvider(apiService: ApiService(), id: id),
          ),
        ],
        child: _buildDetailPage(),
      ),
    );
  }

  Consumer<MovieDetailProvider> _buildDetailPage() {
    return Consumer<MovieDetailProvider>(
      builder: (context, value, child) {
        if (value.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (value.state == ResultState.hasData) {
          var detail = value.result;
          return CustomScrollView(
            slivers: [_buildAppBar(detail), _buildBodyDetail(detail, context)],
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  detail.tagline,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildListGenre(context, detail),
                Row(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(detail.originalLanguage),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_rounded),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(detail.popularity.toString()),
                      ],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text("${detail.runtime} minutes"),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Overall",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  detail.overview,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Documentations",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 6,
                ),
                _buildImageMovie(),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Production Companies",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 6,
                ),
                _buildListCompanies(detail)
              ],
            ),
          ),
        ],
      ),
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
            height: 159,
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
          return Center(child: Text(detail.genres[index].name));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const VerticalDivider(
            indent: 5,
            endIndent: 5,
            color: Colors.black,
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

  SliverAppBar _buildAppBar(Detail value) {
    return SliverAppBar(
      title: Text(value.title),
      // expandedHeight: 250,
      // flexibleSpace: FlexibleSpaceBar(
      //   background: Stack(alignment: Alignment.bottomLeft, children: [
      //     Image.network(
      //       "$getImage${value.backdropPath}",
      //       fit: BoxFit.cover,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: ClipRRect(
      //         borderRadius: const BorderRadius.all(Radius.circular(6)),
      //         child: Image.network(width: 80, "$getImage${value.posterPath}"),
      //       ),
      //     )
      //   ]),
      // ),
    );
  }
}
