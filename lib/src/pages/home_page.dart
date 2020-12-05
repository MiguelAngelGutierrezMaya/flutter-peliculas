import 'package:flutter/material.dart';

/**
 * Providers
 */
import 'package:peliculas/src/providers/movies_provider.dart';

/**
 * Widgets
 */
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();
  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopulars();
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('Cinema movies'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
        // body: SafeArea(child: Text('Hello world!!!!'))
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperTargets(), _footer(context)],
          ),
        ));
  }

  Widget _swiperTargets() {
    return FutureBuilder(
      future: moviesProvider.getOnNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return CardSwiper(
            movies: snapshot.data,
          );
        else
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
    // return CardSwiper(
    //   movies: [1, 2, 3, 4, 5],
    // );
  }

  Widget _footer(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Populares',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            StreamBuilder(
              stream: moviesProvider.streamPopulars,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // snapshot.data?.forEach((p) => print(p.title));
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    movies: snapshot.data,
                    nextPage: moviesProvider.getPopulars,
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      );
}
