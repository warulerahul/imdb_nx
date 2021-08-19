import 'package:flutter/material.dart';
import 'package:imdbnx/movies_list/model/movie_list_model.dart';
import 'package:imdbnx/movies_list/repo/movie_list_api_provider.dart';

/*
* MovieList Repository
*/
class MovieListRepository
{
  /*
  * Local Instance of MovieListApiProvider
  * */
  final movieListApiProvider = MovieListApiProvider();

  /*
  * Fetch list from MovieListApiProvider
  * */
  Future<MovieListModel> fetchMovieList(BuildContext context, int pageNumber) => movieListApiProvider.fetchMovieList(context, pageNumber);
}