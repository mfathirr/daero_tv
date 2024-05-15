import 'package:daero_tv/providers/popular_movie.dart';
import 'package:daero_tv/providers/top_rated_movie.dart';
import 'package:daero_tv/screens/home_screens.dart';
import 'package:daero_tv/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
        )
      ],
      child: MaterialApp(
        title: 'Daero TV',
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
        },
      ),
    );
  }
}
