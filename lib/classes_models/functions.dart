import 'dart:convert';
import 'package:movie_times/api_functions/endpoints.dart';
import 'package:movie_times/classes_models/credits.dart';
import 'package:movie_times/classes_models/genre_model.dart' as genmodel;
import 'package:movie_times/classes_models/movie_model.dart';
import 'package:http/http.dart' as http;


Future<List<Movie>> fetchMovies(String api) async {
  MovieList movieList;
  var res = await http.get(api);
  var decodeRes = jsonDecode(res.body);
  movieList = MovieList.fromJson(decodeRes);
  return movieList.movies;
}
Future<MovieFavResult> fetchSingleMovie(String api) async {
  MovieFavResult movieId;
  var res = await http.get(api);
  Map userMap = jsonDecode(res.body);
  movieId = MovieFavResult.fromJson(userMap);
  return movieId;
}

Future<Credits> fetchCredits(String api) async {
  Credits credits;
  var res = await http.get(api);
  var decodeRes = jsonDecode(res.body);
  credits = Credits.fromJson(decodeRes);
  return credits;
}

Future<genmodel.GenreList> fetchGenres() async {
  genmodel.GenreList genresList;
  var res = await http.get(Endpoints.genresUrl());
  var decodeRes = jsonDecode(res.body);
  genresList = genmodel.GenreList.fromJson(decodeRes);
  return genresList;
}