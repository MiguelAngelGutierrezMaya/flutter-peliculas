import 'package:flutter/material.dart';

/**
 * Models
 */
import 'package:peliculas/src/models/movie_model.dart';
import 'package:peliculas/src/models/actors_models.dart';

/**
 * Providers
 */
import 'package:peliculas/src/providers/movies_provider.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppbar(movie),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10.0,
              ),
              _titlePost(context, movie),
              _description(movie),
              _createCasting(movie)
            ]),
          ),
        ],
      ),
    );
  }

  Widget _createAppbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          background: Container(
            child: FadeInImage(
              image: NetworkImage(movie.getBackgroundImg()),
              placeholder: AssetImage('assets/img/loading.gif'),
              fadeInDuration: Duration(seconds: 2),
              fit: BoxFit.cover,
            ),
          )),
    );
  }

  Widget _titlePost(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(),
                        style: Theme.of(context).textTheme.subtitle1)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _createCasting(Movie movie) {
    final movProvider = new MoviesProvider();
    return FutureBuilder(
        future: movProvider.getCast(movie.id.toString()),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return _createCastsPageView(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _createCastsPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actors.length,
        itemBuilder: (context, i) => _castCard(actors[i]),
      ),
    );
  }

  Widget _castCard(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                height: 150.0,
                fit: BoxFit.cover,
                image: NetworkImage(actor.getImage())),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
