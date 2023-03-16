import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_native_viewer/models/movie.dart';
import 'package:movies_native_viewer/models/movies_api_response.dart';

part 'movies_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesInitial());

  static MoviesCubit instance(BuildContext context) =>
      BlocProvider.of(context, listen: false);

  final MethodChannel _iosPlatformChannel =
      const MethodChannel('test.flutter.methodchannel/iOS');
  final MethodChannel _androidPlatformChannel =
      const MethodChannel('test.flutter.methodchannel/android');

  List<Movie> moviesList = [];
  int currentPage = 1;

  Future<void> fetchNextMoviesPageList() async {
    currentPage += 1;
    fetchMoviesList();
  }

  Future<void> fetchPreviousMoviesPageList() async {
    if (currentPage > 1) {
      currentPage -= 1;
      fetchMoviesList();
    }
  }

  Future<void> refreshMoviesList() async {
    currentPage = 1;
    fetchMoviesList();
  }

  Future<void> fetchMoviesList() async {
    MethodChannel platformChannel;

    if (Platform.isAndroid) {
      platformChannel = _androidPlatformChannel;
    } else if (Platform.isIOS) {
      platformChannel = _iosPlatformChannel;
    } else {
      emit(MoviesRequestNotSupportedForCurrentPlatform());
      return;
    }

    Map<String, dynamic> sendMap = {
      "url": "https://api.themoviedb.org/3/discover/movie",
      "api_key": "838918a0429843af1ee8639f1ad0cf81",
      "language": "en-US",
      "sort_by": "popularity.desc",
      "include_adult": false,
      "include_video": false,
      "page": currentPage.toString(),
      "with_watch_monetization_types": "flatrate"
    };

    Map<String, dynamic> apiResponseJson;
    try {
      final String result =
          await platformChannel.invokeMethod('getFilmsList', sendMap);
      apiResponseJson = json.decode(result);
      MoviesAPIResponse apiResponse =
          MoviesAPIResponse.fromJson(apiResponseJson);
      moviesList = apiResponse.results!;

      emit(MoviesRequestSucceeded());
    } catch (e) {
      if (kDebugMode) {
        print("Can't fetch the method: '$e'.");
      }
      emit(MoviesRequestFailed());
    }
  }
}
