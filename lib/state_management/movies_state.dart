part of 'movies_cubit.dart';

@immutable
abstract class MoviesState {}

class MoviesInitial extends MoviesState {}

class MoviesRequestSent extends MoviesState {}
class MoviesRequestSucceeded extends MoviesState {}
class MoviesRequestFailed extends MoviesState {}
class MoviesRequestNotSupportedForCurrentPlatform extends MoviesState {}
