import 'package:daero_tv/model/movie_genre.dart';
import 'package:daero_tv/providers/genre_movie.dart';
import 'package:daero_tv/providers/notification_provider.dart';
import 'package:daero_tv/providers/popular_movie.dart';
import 'package:daero_tv/providers/top_rated_movie.dart';
import 'package:daero_tv/screens/home_screens.dart';
import 'package:daero_tv/screens/movie_detail.dart';
import 'package:daero_tv/screens/movie_genre.dart';
import 'package:daero_tv/screens/popular_movies.dart';
import 'package:daero_tv/screens/top_rated_movies.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:daero_tv/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MoviePopularProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) => MovieTopRatedProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) => GenreProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Daero TV',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF222222),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          PopularMovies.routeName: (context) => PopularMovies(
                imagePath: ModalRoute.of(context)?.settings.arguments as String,
              ),
          TopRatedMovies.routeName: (context) => TopRatedMovies(
              imagePath: ModalRoute.of(context)?.settings.arguments as String),
          MovieDetailPage.routeName: (context) => MovieDetailPage(
              id: ModalRoute.of(context)?.settings.arguments as int),
          MovieByGenre.routeName: (context) => MovieByGenre(
                genre: ModalRoute.of(context)?.settings.arguments as MovieGenre,
              )
        },
      ),
    );
  }
}
