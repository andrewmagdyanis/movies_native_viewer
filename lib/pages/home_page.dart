import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_native_viewer/models/movie.dart';
import 'package:movies_native_viewer/state_management/movies_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/movie_preview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refresh() async {
    MoviesCubit moviesCubit = MoviesCubit.instance(context);
    moviesCubit.refreshMoviesList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoviesCubit, MoviesState>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        MoviesCubit moviesCubit = MoviesCubit.instance(context);
        List<Movie> moviesList = moviesCubit.moviesList;
        if (state is MoviesRequestSucceeded) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
              ),
              title: Text(widget.title),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(16),
                child: Text("Page: ${moviesCubit.currentPage.toString()}"),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.navigate_before_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      MoviesCubit moviesCubit = MoviesCubit.instance(context);
                      moviesCubit.fetchPreviousMoviesPageList();
                    },
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.lightGreen,
                    child: const Icon(
                      Icons.navigate_next_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      MoviesCubit moviesCubit = MoviesCubit.instance(context);
                      moviesCubit.fetchNextMoviesPageList();
                    },
                  ),
                ],
              ),
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: Center(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: moviesList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 1,
                      color: Colors.black38,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Movie movie = moviesList[index];

                    return MoviePreview(movie: movie);
                  },
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
