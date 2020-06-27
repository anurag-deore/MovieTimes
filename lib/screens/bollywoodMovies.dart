import 'package:flutter/material.dart';
import 'package:movie_times/classes_models/genre_model.dart';
// import 'package:movie_times/classes_models/movie_model.dart';
// import 'package:movie_times/screens/movie_detail.dart';
// import 'package:movie_times/screens/searchpage.dart';

class BollywoodMovies extends StatefulWidget {
  final ThemeData themeData;
  final List<Genres> genres;
  BollywoodMovies({this.themeData, this.genres});
  @override
  _BollywoodMoviesState createState() => _BollywoodMoviesState();
}

class _BollywoodMoviesState extends State<BollywoodMovies> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: widget.themeData.primaryColor,
        elevation: 5.0,
        title: Text(
          'Bollywood Movies',
          style: widget.themeData.textTheme.headline,
        ),iconTheme: IconThemeData(
            color: widget.themeData.accentColor, //change your color here
          ),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: widget.themeData.primaryColor,
        child: Center(
          child: Text('Coming Soon \n\t Stay Tuned..',
          style: widget.themeData.textTheme.body1.copyWith(
            height: 2.0
          ),),
        ),
      ),
    );
  }
}
