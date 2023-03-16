import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_native_viewer/models/movie.dart';
import 'package:movies_native_viewer/state_management/movies_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                preferredSize: Size.fromHeight(16),
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

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                movie.title!,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          movie.overview!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Release date: ${movie.releaseDate!}",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl:
                              "https://api.themoviedb.org/" + movie.posterPath!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: const ColorFilter.mode(
                                    Colors.red, BlendMode.colorBurn),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Container(),
                        ),
                      ]),
                    );
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
