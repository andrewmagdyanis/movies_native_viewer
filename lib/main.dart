import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_native_viewer/pages/home_page.dart';
import 'package:movies_native_viewer/state_management/movies_cubit.dart';
import 'package:movies_native_viewer/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = window.physicalSize;
    final double devicePixelRatio = window.devicePixelRatio;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => MoviesCubit()..fetchMoviesList(),
        ),
      ],
      child: MaterialApp(
        title: 'Movies App',
        debugShowCheckedModeBanner: false,
        theme: Themes(size: size, aspectRatio: devicePixelRatio)
            .themeDataProvider('light'),
        darkTheme: Themes(size: size, aspectRatio: devicePixelRatio)
            .themeDataProvider('dark'),
        themeMode: ThemeMode.dark,
        home: const MyHomePage(title: 'Movies'),
      ),
    );
  }
}
