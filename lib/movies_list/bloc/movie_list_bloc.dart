import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imdbnx/movies_list/model/movie_list_model.dart';
import 'package:imdbnx/movies_list/repo/movie_list_repo.dart';
import 'package:rxdart/subjects.dart';

class MovieListBloc
{
  /*
  * Local Instance of List<MovieData> to store the list
  * */
  List<MovieData> movieDataList = [];

  /*
  * Local Instance of MovieListRepository
  * */
  final movieListRepository = MovieListRepository();

  /*
  * Local Instance of StreamController
  * */
  final StreamController<List<MovieData>> suggestionController = BehaviorSubject<List<MovieData>>();

  Stream<List<MovieData>> get movieList => suggestionController.stream;

  /*
  * Method to fetchResults of Movie List
  * */
  fetchResults(BuildContext context, int pageNumber) async
  {
    MovieListModel resultsModel = await movieListRepository.fetchMovieList(context, pageNumber);
    movieDataList.addAll(resultsModel.movieDataList);
    suggestionController.sink.add(movieDataList);
  }

  /*
  * Method to close StreamController & clear the List<MovieData>
  * */
  dispose()
  {
    suggestionController.close();
    movieDataList.clear();
  }
}

/*
* Instance of MovieListBloc
* */
final movieListBloc = MovieListBloc();