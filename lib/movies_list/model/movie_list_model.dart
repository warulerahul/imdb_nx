
/*
* Model Class or POJO class for Movie List
* */
class MovieListModel
{
  List<MovieData> movieDataList;

  MovieListModel.fromJson(Map<String, dynamic> json)
  {
    List<MovieData> tempMovieDataList = [];
    for(int i = 0; i < json['results'].length; i++)
      {
        MovieData movieData = MovieData(json['results'][i]);
        tempMovieDataList.add(movieData);
      }
    movieDataList = tempMovieDataList;
  }
}

/*
* Model class or POJO class for Single Movie
* */
class MovieData
{
  String movieTitle, movieDescription, moviePosterPath, movieReleaseDate;
  var movieRating;

  MovieData(movieData)
  {
    this.movieTitle = movieData['title'];
    this.movieDescription = movieData['overview'];
    this.moviePosterPath = movieData['poster_path'];
    this.movieReleaseDate = movieData['release_date'];
    this.movieRating = movieData['vote_average'];
  }
}