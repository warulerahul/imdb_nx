import 'package:flutter/material.dart';
import 'package:imdbnx/constants/constants.dart';
import 'dart:ui' as ui;

import 'package:imdbnx/movies_list/model/movie_list_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieData movieData;

  MovieDetailsScreen({this.movieData});

  Color mainColor = const Color(0xff3C3261);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: new Stack(fit: StackFit.expand, children: [
        /*new Image.network(
          MOVIE_DB_IMAGE_URL + movieData.moviePosterPath,
          fit: BoxFit.cover,
        ),
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: new Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),*/
        Container(
          color: Colors.white,
        ),
        new SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  child: new Container(
                    width: 400.0,
                    height: 400.0,
                  ),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      image: new DecorationImage(
                          image: new NetworkImage(
                            MOVIE_DB_IMAGE_URL + movieData.moviePosterPath,),
                          fit: BoxFit.fill),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            offset: new Offset(0.0, 6.0))
                      ]),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                            movieData.movieTitle,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontFamily: 'Poppins'),
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4.0)
                        ),
                        child: new Text(
                          '${movieData.movieRating} / 10',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Poppins'),
                        ),
                      )
                    ],
                  ),
                ),
                new Text(
                    movieData.movieDescription,
                    style: new TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 18.0),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}