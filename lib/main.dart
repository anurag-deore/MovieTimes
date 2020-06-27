import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:movie_times/api_functions/endpoints.dart';
import 'package:movie_times/bloc/change_theme_bloc.dart';
import 'package:movie_times/bloc/change_theme_state.dart';
import 'package:movie_times/classes_models/functions.dart';
import 'package:movie_times/classes_models/genre_model.dart';
import 'package:movie_times/classes_models/movie_model.dart';
import 'package:movie_times/screens/genremovies.dart';
import 'package:movie_times/screens/login.dart';
import 'package:movie_times/screens/movie_detail.dart';
import 'package:movie_times/screens/bollywoodMovies.dart';
import 'package:movie_times/screens/searchpage.dart';
import 'package:movie_times/screens/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
// 1d51cef38e888586924becd5f1cc9b1d

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Movie Times',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple, canvasColor: Colors.transparent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  String name;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Genres> _genres;

  PageController controller = PageController();
  int option;
  final List<Color> colors = [
    Colors.white,
    Color(0xff242248),
    Colors.black,
    Colors.blueAccent
  ];
  final List<Color> borders = [
    Colors.black,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  final List<String> themes = ['Light', 'Dark', 'Amoled', 'Blue'];

  void setFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
    });
  }

  List<GButton> tabs = List();
  List<Color> colors1 = [
    Colors.purple,
    Colors.pink,
    Colors.amber[600],
    Colors.teal
  ];

  @override
  void initState() {
    super.initState();
    setFavorites();
    fetchGenres().then((value) {
      setState(() {
        _genres = value.genres;
      });
    });
    var padding = EdgeInsets.symmetric(horizontal: 12, vertical: 5);
    double gap = 30;

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.purple,
      iconColor: Colors.black,
      textColor: Colors.purple,
      color: Colors.purple.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: LineIcons.home,
      text: 'Home',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.amber[600],
      iconColor: Colors.black,
      textColor: Colors.amber[600],
      color: Colors.amber[600].withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: LineIcons.film,
      text: 'Genres',
    ));
    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.pink,
      iconColor: Colors.black,
      textColor: Colors.pink,
      color: Colors.pink.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: LineIcons.heart_o,
      text: 'Likes',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.teal,
      iconColor: Colors.black,
      textColor: Colors.teal,
      color: Colors.teal.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: LineIcons.cog,
      text: 'Settings',
    ));
  }

  bool onWillPopFn() {
    if (controller.page.round() == controller.initialPage)
      return true;
    else {
      controller.animateToPage(
        0,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: changeThemeBloc,
        builder: (BuildContext context, ChangeThemeState state) {
          return WillPopScope(
            onWillPop: () => Future.sync(onWillPopFn),
            child: Scaffold(
              key: _scaffoldKey,
              extendBody: true,
              drawer: Theme(
                data: state.themeData.copyWith(
                  canvasColor: Colors.black.withOpacity(0.7),
                ),
                child: Drawer(
                  elevation: 0.0,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              accountName: Text(
                                '',
                                style:
                                    state.themeData.textTheme.headline.copyWith(
                                  fontSize: 22.0,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              accountEmail: 
                              ShaderMask(
                                  shaderCallback: (bounds) => RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.3,
                                    colors: [Colors.tealAccent, Colors.green],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: 
                              Text(
                                name ?? 'Account Owner',
                                style:TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: 'Comfortaa'
                                ),
                              ),
                                ),
                              currentAccountPicture: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/images/avatar-11.png',
                                      width: 60.0,
                                      height: 60.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BollywoodMovies(
                                            themeData: state.themeData,
                                            genres: _genres)));
                              },
                              child: ListTile(
                                leading: ShaderMask(
                                  shaderCallback: (bounds) => RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.5,
                                    colors: [Colors.purple, Colors.pinkAccent],
                                    tileMode: TileMode.mirror,
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.whatshot,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  'Bollywood Movies',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Divider(),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    controller.animateToPage(3, 
                                    duration:Duration(milliseconds: 100), 
                                    curve:Curves.linear);
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Settings',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    'Version 1.0.0',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: PageView(
                onPageChanged: (page) {
                  setState(() {
                    selectedIndex = page;
                  });
                },
                controller: controller,
                children: <Widget>[
                  Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: state.themeData.textTheme.body1.color,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      centerTitle: true,
                      title: Text(
                        'The Movie Times',
                        style: state.themeData.textTheme.headline.copyWith(
                            color: state.themeData.textTheme.body1.color),
                      ),
                      backgroundColor: state.themeData.primaryColor,
                      actions: <Widget>[
                        IconButton(
                          color: state.themeData.textTheme.body1.color,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            if (_genres != null) {
                              final Movie result = await showSearch(
                                  context: context,
                                  delegate: MovieSearch(
                                      themeData: state.themeData,
                                      genres: _genres));
                              if (result != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailPage(
                                        movie: result,
                                        themeData: state.themeData,
                                        genres: _genres,
                                        heroId: '${result.id}search'),
                                  ),
                                );
                              }
                            }
                          },
                        )
                      ],
                    ),
                    body: Container(
                      color: state.themeData.primaryColor,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          DiscoverMovies(
                            themeData: state.themeData,
                            genres: _genres,
                          ),
                          ScrollingMovies(
                            themeData: state.themeData,
                            title: 'Now Playing',
                            api: Endpoints.nowPlayingMoviesUrl(1),
                            genres: _genres,
                          ),
                          ScrollingMovies(
                            themeData: state.themeData,
                            title: 'Popular',
                            api: Endpoints.popularMoviesUrl(1),
                            genres: _genres,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: state.themeData.textTheme.body1.color,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      backgroundColor: state.themeData.primaryColor,
                      elevation: 0.0,
                      iconTheme: IconThemeData(
                          color: state.themeData.primaryColor,
                          opacity: 1.0,
                          size: 25.0),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(LineIcons.refresh),
                          onPressed: () {},
                        ),
                        IconButton(
                          color: state.themeData.textTheme.body1.color,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            if (_genres != null) {
                              final Movie result = await showSearch(
                                  context: context,
                                  delegate: MovieSearch(
                                      themeData: state.themeData,
                                      genres: _genres));
                              if (result != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailPage(
                                        movie: result,
                                        themeData: state.themeData,
                                        genres: _genres,
                                        heroId: '${result.id}search'),
                                  ),
                                );
                              }
                            }
                          },
                        )
                      ],
                      title: Text(
                        'Genre',
                        style: state.themeData.textTheme.headline,
                      ),
                    ),
                    body: _genres == null
                        ? Container(child: CircularProgressIndicator())
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            color: state.themeData.primaryColor,
                            child: GridView.builder(
                                itemCount: _genres.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 14.0,
                                        // l
                                        mainAxisSpacing: 14.0,
                                        childAspectRatio: 1.75),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _genres[index].name == 'Documentary'
                                          ? 
                                              print(state.themeData.primaryColor.toString())
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GenreMovies(
                                                        themeData:
                                                            state.themeData,
                                                        genre: _genres[index],
                                                        genres: _genres,
                                                      )));
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      height: 125,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                          'assets/images/${_genres[index].name}.jpg') ??
                                                      AssetImage(
                                                          'assets/images/w.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            Positioned(
                                              top: 48.0,
                                              left: 10.0,
                                              right: 10.0,
                                              child: 
                                              state.themeData.primaryColor.toString() == "Color(0xffffffff)" ?
                                              Text(
                                                _genres[index].name,
                                                style: state.themeData.textTheme.body1.copyWith(color:Colors.white),
                                              )
                                              : Text(
                                                _genres[index].name,
                                                style: state.themeData.textTheme
                                                    .headline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ),
                  Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: state.themeData.textTheme.body1.color,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      backgroundColor: state.themeData.primaryColor,
                      elevation: 0.0,
                      title: Text(
                        'Favorites',
                        style: state.themeData.textTheme.headline,
                      ),
                      actions: <Widget>[
                        IconButton(
                          color: state.themeData.textTheme.body1.color,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            if (_genres != null) {
                              final Movie result = await showSearch(
                                  context: context,
                                  delegate: MovieSearch(
                                      themeData: state.themeData,
                                      genres: _genres));
                              if (result != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailPage(
                                        movie: result,
                                        themeData: state.themeData,
                                        genres: _genres,
                                        heroId: '${result.id}search'),
                                  ),
                                );
                              }
                            }
                          },
                        )
                      ],
                    ),
                    body: Container(
                      color: state.themeData.primaryColor,
                      child:
                          // Text('data'),
                          GetFavoriteList(
                        themeData: state.themeData,
                        // genres: _genres,
                      ),
                    ),
                  ),
                  Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: state.themeData.textTheme.body1.color,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                      backgroundColor: state.themeData.primaryColor,
                      elevation: 0.0,
                      title: Text(
                        'Settings',
                        style: state.themeData.textTheme.headline,
                      ),
                      actions: <Widget>[
                        IconButton(
                          color: state.themeData.textTheme.body1.color,
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            if (_genres != null) {
                              final Movie result = await showSearch(
                                  context: context,
                                  delegate: MovieSearch(
                                      themeData: state.themeData,
                                      genres: _genres));
                              if (result != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailPage(
                                        movie: result,
                                        themeData: state.themeData,
                                        genres: _genres,
                                        heroId: '${result.id}search'),
                                  ),
                                );
                              }
                            }
                          },
                        )
                      ],
                    ),
                    body: Container(
                      color: state.themeData.primaryColor,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            state.themeData.accentColor,
                                        radius: 40,
                                        child: Icon(
                                          Icons.person_outline,
                                          size: 40,
                                          color: state.themeData.primaryColor,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      shape: StadiumBorder(),
                                      onPressed: () async {
                                        final respo = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(
                                                      themeData:
                                                          state.themeData,
                                                    )));
                                        if(respo == true){
                                        setState(() {
                                          setFavorites();
                                        });
                                        }
                                      },
                                      child: Text(
                                        name ?? 'Account Name',
                                        style: state.themeData.textTheme.body2
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 150.0,
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Choose Theme',
                                      style: state.themeData.textTheme.body2,
                                    ),
                                  ],
                                ),
                                subtitle: SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: 4,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Stack(
                                          children: <Widget>[
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                borders[index]),
                                                        color: colors[index]),
                                                  ),
                                                ),
                                                Text(themes[index],
                                                    style: state.themeData
                                                        .textTheme.body2)
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        switch (index) {
                                                          case 0:
                                                            changeThemeBloc
                                                                .onLightThemeChange();
                                                            break;
                                                          case 1:
                                                            changeThemeBloc
                                                                .onDarkThemeChange();
                                                            break;
                                                          case 2:
                                                            changeThemeBloc
                                                                .onAmoledThemeChange();
                                                            break;
                                                          case 3:
                                                            changeThemeBloc
                                                                .onRedThemeChange();
                                                            break;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: state.themeData
                                                                  .primaryColor ==
                                                              colors[index]
                                                          ? Icon(Icons.done,
                                                              color: state
                                                                  .themeData
                                                                  .accentColor)
                                                          : Container(),
                                                    ),
                                                  ),
                                                ),
                                                Text(themes[index],
                                                    style: state.themeData
                                                        .textTheme.body2)
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: -10,
                            blurRadius: 60,
                            color: Colors.black.withOpacity(.20),
                            offset: Offset(0, 15))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5),
                    child: GNav(
                        tabs: tabs,
                        selectedIndex: selectedIndex,
                        onTabChange: (index) {
                          print(index);
                          setState(() {
                            selectedIndex = index;
                          });
                          controller.jumpToPage(index);
                        }),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
