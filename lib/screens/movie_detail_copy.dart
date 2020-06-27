import 'package:flutter/material.dart';
import 'package:movie_times/api_functions/endpoints.dart';
import 'package:movie_times/classes_models/credits.dart';
import 'package:movie_times/classes_models/movie_model.dart';
import 'package:movie_times/screens/widgets.dart' as widgets;
import 'package:movie_times/tmbd/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailPageCopy extends StatefulWidget {
  final MovieFavResult movie;
  final ThemeData themeData;
  final String heroId;
  // final List<GenresList> genres;

  MovieDetailPageCopy({
    this.movie,
    this.themeData,
    this.heroId,
    // this.genres,
  });
  @override
  _MovieDetailPageCopyState createState() => _MovieDetailPageCopyState();
}

class _MovieDetailPageCopyState extends State<MovieDetailPageCopy> {
 final prefs = SharedPreferences.getInstance();
 bool isLiked = false;
 List favorites;

setFavorites()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
   favorites = prefs.getStringList('my_favorites');
    if(favorites.contains(widget.movie.id.toString())){
      setState(() {
        isLiked = true;
      });
  }
}
removeLike()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   favorites = prefs.getStringList('my_favorites');
   favorites.remove(widget.movie.id.toString());
   prefs.setStringList('my_favorites', favorites);
  Navigator.pop(context,'true');
}
addLike()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   favorites = prefs.getStringList('my_favorites') ?? <String>[];
   favorites.add(widget.movie.id.toString());
   prefs.setStringList('my_favorites', favorites);
}

 @override
  void initState() {
    super.initState();
    setFavorites();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    widget.movie.backdropPath == null
                        ? Image.asset(
                            'assets/images/na.jpg',
                            fit: BoxFit.cover,
                          )
                        : FadeInImage(
                            width: double.infinity,
                            height: double.infinity,
                            image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                'original/' +
                                widget.movie.backdropPath),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                          colors: [
                            widget.themeData.accentColor,
                            widget.themeData.accentColor.withOpacity(0.3),
                            widget.themeData.accentColor.withOpacity(0.2),
                            widget.themeData.accentColor.withOpacity(0.1),
                          ],
                          stops: [0.0, 0.25, 0.5, 0.75],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: widget.themeData.accentColor,
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      print('share');
                    },
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 78, 16, 16),
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: widget.themeData.primaryColor,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 130.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 10.0,),
                                        Text(
                                          widget.movie.title,
                                          style: widget
                                              .themeData.textTheme.body1.copyWith(fontSize: 23.0),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.star,
                                                  color: Colors.yellow),
                                              Text(
                                                widget.movie.voteAverage+' / 10',
                                                style: widget
                                                    .themeData.textTheme.body2,
                                              ),
                                                  SizedBox(width: 25.0,),
                                              Text(
                                                (widget.movie.voteCount).toString(),
                                                style: TextStyle(color: Colors.greenAccent,fontSize: 18.0),
                                              ),
                                                  SizedBox(width: 5.0,),
                                              Text('Votes',style: widget
                                                    .themeData.textTheme.body2,)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                  padding: EdgeInsets.all(5.0),
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      children: <Widget>[
                                        // widget.genres == null
                                        //     ? Text('')
                                        //     : widgets.GenreList(
                                        //         themeData: widget.themeData,
                                        //         genres: widget.movie.genreIds,
                                        //         totalGenres: widget.genres,
                                        //       ),
                                              Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,top: 15.0),
                                              child: Text(
                                                'Overview',
                                                style: widget
                                                    .themeData.textTheme.body2,
                                              ),
                                            ),
                                          ],
                                        ),
                                         Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            widget.movie.overview,
                                            style: widget
                                                .themeData.textTheme.caption,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12.0, bottom: 4.0),
                                              child: Text(
                                                'Release date : ${widget.movie.releaseDate}',
                                                style: widget
                                                    .themeData.textTheme.body2,
                                              ),
                                            ),
                                          ],
                                        ),
                                        widgets.ScrollingArtists(
                                          api: Endpoints.getCreditsUrl(
                                              widget.movie.id),
                                          title: 'Cast',
                                          tapButtonText: 'View All',
                                          themeData: widget.themeData,
                                          onTap: (cast){
                                            modalBottomSheetMenu(cast);
                                          },
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
                      Positioned(
                        top: 35,
                        right: 25,
                        child:RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color:Colors.pink
                            ),
                          color: Colors.white,
                          onPressed: (){
                            setState(() {
                              if(isLiked){
                                removeLike();
                              }
                              else{
                                addLike();
                              }
                              isLiked = !isLiked;
                            });
                          },
                          label: Text(
                            isLiked ? 'Added to Favorites' : 'Add to Favorites',
                            style: widget.themeData.textTheme.body2.copyWith(color: Colors.pink,fontSize: 14.0) 
                            ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 40,
                        child: Hero(
                          tag: widget.heroId,
                          child: SizedBox(
                            width: 100,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: widget.movie.posterPath == null
                                  ? Image.asset(
                                      'assets/images/na.jpg',
                                      fit: BoxFit.cover,
                                    )
                                  : FadeInImage(
                                      image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                          'w500/' +
                                          widget.movie.posterPath),
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void modalBottomSheetMenu(Cast cast) {
    // double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            // height: height / 2,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                      padding: const EdgeInsets.only(top: 54),
                      decoration: BoxDecoration(
                          color: widget.themeData.primaryColor,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(16.0),
                              topRight: const Radius.circular(16.0))),
                      child: Center(
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${cast.name}',
                                    style: widget.themeData.textTheme.body1,
                                  ),
                                  Text(
                                    'as',
                                    style: widget.themeData.textTheme.body1,
                                  ),
                                  Text(
                                    '${cast.character}',
                                    style: widget.themeData.textTheme.body1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.themeData.primaryColor,
                            border: Border.all(
                                color: widget.themeData.accentColor, width: 3),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: cast.profilePath == null
                                    ? AssetImage('assets/images/na.jpg')
                                    : NetworkImage(TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        cast.profilePath)),
                            shape: BoxShape.circle),
                      ),
                    ))
              ],
            ),
          );
        });
  }

}
