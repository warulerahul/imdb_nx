import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imdbnx/constants/constants.dart';
import 'package:imdbnx/movies_list/bloc/movie_list_bloc.dart';
import 'package:imdbnx/movies_list/model/movie_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:imdbnx/screens/movie_details_screen.dart';
import 'package:imdbnx/utils/bottom_sheets.dart';
import 'package:imdbnx/utils/utils.dart';
import 'package:page_transition/page_transition.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {

  /*
  * Global Instance of Boolean Variables
  * */
  bool isSearchIconClicked = false;

  /*
  * DateTime Object For Double Back Press
  * */
  DateTime currentBackPressTime;

  /*
  * Global Instance of Integer Variables
  * */
  int pageNumber = 1;

  /*
  * Global Instance of ScrollController
  * */
  ScrollController scrollController = ScrollController();

  /*
  * Global Instance of Scaffold Key
  * */
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*
    * Fetch Movie List Data
    * */
    movieListBloc.fetchResults(context, pageNumber);

    /*
    * Listen to the scroll of ListView.builder
    * */
    scrollController.addListener(() {

      /*
      * Check if the ListView has reached to the bottom of the movie list
      * */
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent)
        {
          /*
          * Update the page number
          * */
          setState(() {
            pageNumber++;
          });

          /*
          * After scrolling to the bottom of ListView, again fetch the movie list
          * */
          movieListBloc.fetchResults(context, pageNumber);
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*
        * Check if the search part is visible and fetch the movie list
        * */
        if(isSearchIconClicked)
          {
            setState(() {
              isSearchIconClicked = false;
            });

            Future.delayed(Duration(milliseconds: 500), (){
              movieListBloc.fetchResults(context, pageNumber);
            });
          }
        else
          {

            /*
            * Double Click Back for exit
            * */
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime) > Duration(seconds: 2))
            {
              currentBackPressTime = now;
              Fluttertoast.showToast(
                  msg: 'Please click back again to exit.',
                  backgroundColor: Colors.grey,
                  textColor: Colors.white);
              return false;
            }
            return true;
          }

        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            isSearchIconClicked ? 'Search Movie' : 'Now Playing Movies',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0),),
          centerTitle: true,
          actions: [

            /*
            * Check if search icon is clicked and simultaneously change the visibility of Search Icon
            * */
            isSearchIconClicked
            ? Container()
            : InkWell(
                borderRadius: BorderRadius.circular(40.0),
                onTap: (){

                  setState(() {
                    isSearchIconClicked = true;
                  });
                },
                splashColor: Colors.grey[200],
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              )
          ],
        ),
          body: Container(
            color: Colors.white,
            child: isSearchIconClicked // Check if search icon is clicked and simultaneously change the visibility of body
                    ? Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: isSearchIconClicked == true ? true : false,
                        child: searchMovieBody())
                    : Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: isSearchIconClicked == false ? true : false,
                        child: movieListBody())
          )
      ),
    );
  }

  /*
  * Method to return search widget
  * */
  Widget searchMovieBody()
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: TypeAheadField(
        hideSuggestionsOnKeyboardHide: false,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Which movie are you looking for?',
              suffixIcon: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  splashColor: Colors.grey[200],
                  onTap: (){
                    setState(() {
                      isSearchIconClicked = false;
                    });

                    Utils.hideKeyBoard();

                    Future.delayed(Duration(milliseconds: 500), (){
                      movieListBloc.fetchResults(context, pageNumber);
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              )
            )
        ),
        suggestionsCallback: (pattern) async {
          return searchMovie(pattern.toString());
        },
        itemBuilder: (context, MovieData movieData) {
          return ListTile(
            leading: Container(
              width: 40.0,
              height: 40.0,
              child: movieData.moviePosterPath == null || movieData.moviePosterPath == ''
                  ? Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  : ClipRRect(
                    child: Image.network(
                      MOVIE_DB_IMAGE_URL + movieData.moviePosterPath,
                      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null ?
                            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
              ),
            ),
            title: Text(
              movieData.movieTitle,
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          );
        },
        loadingBuilder: (context){
          return SpinKitThreeBounce(color: Colors.black, size: 30.0,);
        },
        noItemsFoundBuilder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'No movie found',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          );
        },
        onSuggestionSelected: (MovieData movieData) {
          Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300), type: PageTransitionType.leftToRight, child: MovieDetailsScreen(movieData: movieData)));
        },
      ),
    );
  }

  /*
  * Method to return movie list widget
  * */
  Widget movieListBody()
  {
    return Container(
      color: Colors.white,
      child: StreamBuilder<List<MovieData>>(
        stream: movieListBloc.movieList,
        builder: (BuildContext context, AsyncSnapshot<List<MovieData>> snapshot){
          if(snapshot.hasError)
            print('STREAM MOVIE LIST ERROR: ${snapshot.error}');

          switch(snapshot.connectionState)
          {
            case ConnectionState.waiting:
              return SpinKitThreeBounce(color: Colors.black, size: 30.0,);

            default:
              return movieListWidget(snapshot.data);
          }
        },
      ),
    );
  }

  /*
  * Method to return ListView.builder of Movie List
  * */
  Widget movieListWidget(List<MovieData> movieList)
  {
    return ListView.builder(
        controller: scrollController,
        itemCount: movieList.length + 1,
        itemBuilder: (context, index){
          return index >= movieList.length
              ? SpinKitThreeBounce(color: Colors.black, size: 30.0,)
              : Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300), type: PageTransitionType.leftToRight, child: MovieDetailsScreen(movieData: movieList[index])));
                      },
                      splashColor: Colors.grey[200],
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: 100.0,
                              height: 100.0,
                              child: movieList[index].moviePosterPath == null || movieList[index].moviePosterPath == ''
                                  ? Icon(
                                Icons.movie,
                                color: Colors.white,
                                size: 40.0,
                              )
                                  : ClipRRect(
                                child: Image.network(
                                  MOVIE_DB_IMAGE_URL + movieList[index].moviePosterPath,
                                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null ?
                                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      child: Text(
                                        movieList[index].movieTitle,
                                        style: TextStyle(fontFamily: 'Poppins', fontSize: 18.0),
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                      ),
                                    ),

                                    Container(
                                      child: Text(
                                        movieList[index].movieDescription ?? 'NA',
                                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14.0, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                    ),

                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                      margin: EdgeInsets.symmetric(vertical: 4.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: Text(
                                        '${movieList[index].movieRating.toString()} / 10' ?? 'NA',
                                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14.0, color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: Divider(
                      color: Colors.grey,
                      endIndent: 10.0,
                      indent: 10.0,
                    ),
                  )
                ],
              );
        });
  }

  /*
  * Method to search movie
  * */
  Future<List<MovieData>> searchMovie(String searchQuery) async
  {
    /*
    * Generate query parameters
    * */
    Map<String, String> queryParameters =
    {
      'api_key': API_KEY,
      'language': 'en-US',
      'query': searchQuery
    };

    /*
    * Generate uri using host, endpoint and query parameters
    * */
    var uri = Uri.https(MOVIE_DB_BASE_URL, MOVIE_DB_SEARCH_API_END_POINT_URL, queryParameters);

    try
    {
      var response = await http.get(
          uri
      );

      /*
      * Check for response status code,
      * If it is HttpStatus.ok then return the movie list.
      * */
      if(response.statusCode == HttpStatus.ok)
      {
        MovieListModel movieListModel = MovieListModel.fromJson(jsonDecode(response.body));
        return movieListModel.movieDataList;
      }
      else
      {
        /*
        * If the response status code in other than HttpStatus.ok,
        * then show the error code to user.
        * */
        showSnackBarMethod('Something went wrong. Error code: ${response.statusCode}');
      }
    }
    /*
    * If internet connection is lost, then show the NoInternetBottomSheet
    * */
    on SocketException catch (_) {
      BottomSheets().noInternetBottomSheet(context, () {
        Navigator.pop(context);
      });
    }

    return null;
  }

  /*
  * Method to show SnackBar
  * */
  showSnackBarMethod(String message)
  {
    final snackBar = new SnackBar(
      content: new Text(message), duration: new Duration(seconds: 3), behavior: SnackBarBehavior.floating,);

    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
