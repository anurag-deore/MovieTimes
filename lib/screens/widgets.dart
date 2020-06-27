import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_times/api_functions/endpoints.dart';
import 'package:movie_times/screens/movie_detail_copy.dart';
import 'package:movie_times/classes_models/cell_model.dart';
import 'package:movie_times/classes_models/credits.dart';
import 'package:movie_times/classes_models/functions.dart';
import 'package:movie_times/classes_models/genre_model.dart';
import 'package:movie_times/classes_models/movie_model.dart';
import 'package:movie_times/screens/castcrew.dart';
import 'package:movie_times/screens/cell.dart';
import 'package:movie_times/screens/genremovies.dart';
import 'package:movie_times/screens/movie_detail.dart';
import 'package:movie_times/tmbd/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComComp {
  static Padding text(String text, FontWeight fontWeight, double fontSize,
      List padding, Color color, TextOverflow overflow) {
    return Padding(
      padding: new EdgeInsets.only(
          left: padding[0],
          right: padding[1],
          top: padding[2],
          bottom: padding[3]),
      child: Text(
        text,
        textAlign: TextAlign.left,
        overflow: overflow,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }

  static AppBar getAppBar(Color color, String title) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Center(
        child: new Text(title.toUpperCase()),
      ),
      actions: <Widget>[],
    );
  }

  static CircularProgressIndicator circularProgress() {
    return CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  static GestureDetector internetErrorText(Function callback) {
    return GestureDetector(
      onTap: callback,
      child: Center(
        child: Text(MESSAGES.INTERNET_ERROR),
      ),
    );
  }

  static Padding homeGrid(
      AsyncSnapshot<List<CellModel>> snapshot, Function gridClicked) {
    return Padding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 30.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Cell(snapshot.data[index]),
            onTap: () => gridClicked(context, snapshot.data[index]),
          );
        },
      ),
    );
  }

  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        MESSAGES.INTERNET_ERROR_RETRY,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () => fetch(),
    );
  }
}

class DiscoverMovies extends StatefulWidget {
  final ThemeData themeData;
  final List<Genres> genres;
  DiscoverMovies({this.themeData, this.genres});
  @override
  _DiscoverMoviesState createState() => _DiscoverMoviesState();
}

class _DiscoverMoviesState extends State<DiscoverMovies> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.discoverMoviesUrl(1)).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Text('Discover', style: widget.themeData.textTheme.body1),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: moviesList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Swiper(
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                      movie: moviesList[index],
                                      themeData: widget.themeData,
                                      genres: widget.genres,
                                      heroId:
                                          '${moviesList[index].id}discover')));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Hero(
                                tag: '${moviesList[index].id}discover',
                                child: FadeInImage(
                                  image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                      'w500/' +
                                      moviesList[index].posterPath),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  placeholder:
                                      AssetImage('assets/images/loading.gif'),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  widthFactor: 1,
                                  heightFactor: 0.3,
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.black, Colors.black26],
                                      ).createShader(
                                        Rect.fromLTRB(
                                            0, rect.height, rect.width, 0),
                                      );
                                    },
                                    blendMode: BlendMode.difference,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 20.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Text(
                                        moviesList[index].title,
                                        style: widget.themeData.textTheme.body1
                                            .copyWith(shadows: [
                                          Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.white,
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ], color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: moviesList.length,
                  viewportFraction: 0.7,
                  scale: 0.9,
                ),
        ),
      ],
    );
  }
}

class GenreList extends StatefulWidget {
  final ThemeData themeData;
  final List<int> genres;
  final List<Genres> totalGenres;
  GenreList({this.themeData, this.genres, this.totalGenres});

  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Genres> _genres = new List();
  @override
  void initState() {
    super.initState();
    widget.totalGenres.forEach((valueGenre) {
      widget.genres.forEach((genre) {
        if (valueGenre.id == genre) {
          _genres.add(valueGenre);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: _genres == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _genres.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GenreMovies(
                                        themeData: widget.themeData,
                                        genre: _genres[index],
                                        genres: widget.totalGenres,
                                      )));
                        },
                        child: Chip(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: widget.themeData.accentColor),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          label: Text(
                            _genres[index].name,
                            style: widget.themeData.textTheme.body2,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}

class ParticularGenreMovies extends StatefulWidget {
  final ThemeData themeData;
  final String api;
  final List<Genres> genres;
  ParticularGenreMovies({this.themeData, this.api, this.genres});
  @override
  _ParticularGenreMoviesState createState() => _ParticularGenreMoviesState();
}

class _ParticularGenreMoviesState extends State<ParticularGenreMovies> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api).then((value) {
      // print(value.length);
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor.withOpacity(0.8),
      child: moviesList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: moviesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                  movie: moviesList[index],
                                  themeData: widget.themeData,
                                  genres: widget.genres,
                                  heroId: '${moviesList[index].id}')));
                    },
                    child: Container(
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: widget.themeData.primaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      width: 1,
                                      color: widget.themeData.accentColor)),
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 118.0, top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      moviesList[index].title,
                                      style: widget.themeData.textTheme.body1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            moviesList[index].voteAverage,
                                            style: widget
                                                .themeData.textTheme.body2,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 8,
                            child: Hero(
                              tag: '${moviesList[index].id}',
                              child: SizedBox(
                                width: 100,
                                height: 125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage(
                                    image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        moviesList[index].posterPath),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        AssetImage('assets/images/loading.gif'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ScrollingArtists extends StatefulWidget {
  final ThemeData themeData;
  final String api, title, tapButtonText;
  final Function(Cast) onTap;
  ScrollingArtists(
      {this.themeData, this.api, this.title, this.tapButtonText, this.onTap});
  @override
  _ScrollingArtistsState createState() => _ScrollingArtistsState();
}

class _ScrollingArtistsState extends State<ScrollingArtists> {
  Credits credits;
  @override
  void initState() {
    super.initState();
    fetchCredits(widget.api).then((value) {
      setState(() {
        credits = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        credits == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.title, style: widget.themeData.textTheme.body2),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.title,
                        style: widget.themeData.textTheme.body2),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CastAndCrew(
                                    themeData: widget.themeData,
                                    credits: credits,
                                  )));
                    },
                    child: Text(widget.tapButtonText,
                        style: widget.themeData.textTheme.caption),
                  ),
                ],
              ),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: credits == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: credits.cast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.onTap(credits.cast[index]);
                        },
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child:
                                        credits.cast[index].profilePath == null
                                            ? Image.asset(
                                                'assets/images/na.jpg',
                                                fit: BoxFit.cover,
                                              )
                                            : FadeInImage(
                                                image: NetworkImage(
                                                    TMDB_BASE_IMAGE_URL +
                                                        'w500/' +
                                                        credits.cast[index]
                                                            .profilePath),
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    'assets/images/loading.gif'),
                                              ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  credits.cast[index].name,
                                  style: widget.themeData.textTheme.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ScrollingMovies extends StatefulWidget {
  final ThemeData themeData;
  final String api, title;
  final List<Genres> genres;
  ScrollingMovies({this.themeData, this.api, this.title, this.genres});
  @override
  _ScrollingMoviesState createState() => _ScrollingMoviesState();
}

class _ScrollingMoviesState extends State<ScrollingMovies> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title,
                  style: widget.themeData.textTheme.headline),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: moviesList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: moviesList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                      movie: moviesList[index],
                                      themeData: widget.themeData,
                                      genres: widget.genres,
                                      heroId:
                                          '${moviesList[index].id}${widget.title}')));
                        },
                        child: Hero(
                          tag: '${moviesList[index].id}${widget.title}',
                          child: SizedBox(
                            width: 100,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage(
                                      image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                          'w500/' +
                                          moviesList[index].posterPath),
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    moviesList[index].title,
                                    style: widget.themeData.textTheme.body2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class GetFavoriteList extends StatefulWidget {
  final ThemeData themeData;
  GetFavoriteList({this.themeData});
  @override
  _GetFavoriteListState createState() => _GetFavoriteListState();
}

class _GetFavoriteListState extends State<GetFavoriteList> {
  List favorites;
  List<MovieFavResult> allFavorites = List<MovieFavResult>();

  setFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    favorites = prefs.getStringList('my_favorites');
    if (favorites != null) {
      favorites.forEach((name) {
        fetchSingleMovie(Endpoints.movieSearchId(name)).then((value) {
          setState(() {
            allFavorites.add(value);
          });
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      setFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor,
      child: favorites == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset("assets/images/min1.png"),
                ),
                Text(
                  "No Favorites Added",
                  style:
                      widget.themeData.textTheme.body1.copyWith(fontSize: 27.0),
                ),
              ],
            )
          : allFavorites == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : allFavorites.length == 0
                  ? favorites.length == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image.asset("assets/images/min1.png"),
                            ),
                            Text(
                              "No Favorites Added",
                              style: widget.themeData.textTheme.body1
                                  .copyWith(fontSize: 27.0),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Loading your favorites..!",
                            style: widget.themeData.textTheme.body2,
                          ),
                        )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: allFavorites.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MovieDetailPageCopy(
                                        movie: allFavorites[index],
                                        themeData: widget.themeData,
                                        // genres: widget.genres,
                                        heroId: '${allFavorites[index].id}')));
                          },
                          child: Container(
                            height: 150,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: widget.themeData.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                widget.themeData.accentColor)),
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 118.0, top: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            allFavorites[index].title,
                                            style: widget
                                                .themeData.textTheme.body1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[800],
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  allFavorites[index]
                                                          .voteAverage +
                                                      " / 10",
                                                  style: widget.themeData
                                                      .textTheme.body2,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 8,
                                  child: Hero(
                                    tag: '${allFavorites[index].id}',
                                    child: SizedBox(
                                      width: 100,
                                      height: 125,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              TMDB_BASE_IMAGE_URL +
                                                  'w500/' +
                                                  allFavorites[index]
                                                      .posterPath),
                                          fit: BoxFit.cover,
                                          placeholder: AssetImage(
                                              'assets/images/loading.gif'),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class SearchMovieWidget extends StatefulWidget {
  final ThemeData themeData;
  final String query;
  final List<Genres> genres;
  final Function(Movie) onTap;
  SearchMovieWidget({this.themeData, this.query, this.genres, this.onTap});
  @override
  _SearchMovieWidgetState createState() => _SearchMovieWidgetState();
}

class _SearchMovieWidgetState extends State<SearchMovieWidget> {
  List<Movie> moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.movieSearchUrl(widget.query)).then((value) {
      // print(value.length);
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor,
      child: moviesList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : moviesList.length == 0
              ? Center(
                  child: Text(
                    "Oops! couldn't find the movie",
                    style: widget.themeData.textTheme.body2,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: moviesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.onTap(moviesList[index]);
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 70,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: moviesList[index].posterPath == null
                                        ? Image.asset(
                                            'assets/images/na.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : FadeInImage(
                                            image: NetworkImage(
                                                TMDB_BASE_IMAGE_URL +
                                                    'w500/' +
                                                    moviesList[index]
                                                        .posterPath),
                                            fit: BoxFit.cover,
                                            placeholder: AssetImage(
                                                'assets/images/loading.gif'),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          moviesList[index].title,
                                          style:
                                              widget.themeData.textTheme.body1,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              moviesList[index].voteAverage,
                                              style: widget
                                                  .themeData.textTheme.body2,
                                            ),
                                            Icon(Icons.star,
                                                color: Colors.green)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Divider(
                                color: widget.themeData.accentColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
