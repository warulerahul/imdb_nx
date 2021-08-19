import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:imdbnx/constants/constants.dart';
import 'package:imdbnx/movies_list/model/movie_list_model.dart';
import 'package:imdbnx/utils/bottom_sheets.dart';

class MovieListApiProvider
{
  /*
  * Local Instance of Http Client
  * */
  Client client = Client();

  /*
  * Method to fetch movie list
  * */
  Future<MovieListModel> fetchMovieList(BuildContext context, int pageNumber) async
  {
    /*
    * Generate query parameters
    * */
    Map<String, String> queryParameters =
    {
      'api_key': API_KEY,
      'language': 'en-US',
      'page': pageNumber.toString()
    };

    /*
    * Generate uri using host, endpoint and query parameters
    * */
    var uri = Uri.https(MOVIE_DB_BASE_URL, MOVIE_DB_END_POINT_URL, queryParameters);

    try
    {
      var response = await client.get(
          uri
      );

      /*
      * Check for response status code,
      * if it is HttpStatus.ok then return the movie list.
      * */
      if(response.statusCode == HttpStatus.ok)
      {
        return MovieListModel.fromJson(jsonDecode(response.body));
      }
      else
      {
        /*
        * If the response status code in other than HttpStatus.ok,
        * then show the error code to user.
        * */
        final snackBar = SnackBar(content: Text('Something went wrong. Error code: ${response.statusCode}'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
    /*
    * If internet connection is lost, then show the NoInternetBottomSheet
    * */
    on SocketException catch (_) {
      BottomSheets().noInternetBottomSheet(context, () {
        Navigator.pop(context);

        /*
        * Call the method to fetch Results List
        * */
        fetchMovieList(context, pageNumber);
      });
    }

    return null;
  }
}