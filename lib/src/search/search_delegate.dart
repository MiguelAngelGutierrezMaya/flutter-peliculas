import 'package:flutter/material.dart';

/**
 * Providers
 */
import 'package:peliculas/src/providers/movies_provider.dart';

/**
 * Models
 */
import 'package:peliculas/src/models/movie_model.dart';

class DataSearch extends SearchDelegate {
  String selection;
  final MoviesProvider moviesProvider = new MoviesProvider();
  final movies = [];
  final recentMovies = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Appbar actions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon left Appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Create results to show
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show the suggestion that show when person write
    // final suggestList = (query.isEmpty)
    //     ? recentMovies
    //     : movies
    //         .where((element) =>
    //             element.toLowerCase().startsWith(query.toLowerCase()))
    //         .toList();

    // return ListView.builder(
    //   itemCount: suggestList.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(suggestList[i]),
    //       onTap: () {
    //         selection = suggestList[i];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
        future: moviesProvider.findMovie(query),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final movies = snapshot.data;
            return ListView(
              children: movies.map((movie) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.contain,
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.originalTitle),
                  onTap: () {
                    close(context, null);
                    movie.uniqueId = '';
                    Navigator.pushNamed(context, 'detail', arguments: movie);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
