import 'dart:convert';
import 'dart:async';

/*
 * Libraries 
 */
import 'package:http/http.dart' as http;

/*
 * Models 
 */
import 'package:peliculas/src/models/movie_model.dart';

class MoviesProvider {
  String _apikey = '66c2c8cb25a0824609eb7a7844ce1d08';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularsPage = 0;
  bool _loading = false;

  List<Movie> _populars = new List();

  final _streamPopularsController = StreamController<
      List<
          Movie>>.broadcast(); //Without broadcast the stream will be only one service

  Function(List<Movie>) get sinkPopulars => _streamPopularsController.sink.add;

  Stream<List<Movie>> get streamPopulars => _streamPopularsController.stream;

  void disposeStreams() {
    _streamPopularsController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Movie>> getOnNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await this._processResponse(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_loading) return [];
    _loading = true;
    _popularsPage++;
    print('Loading next');
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularsPage.toString()
    });

    final resp = await this._processResponse(url);
    _populars.addAll(resp);
    sinkPopulars(_populars);
    _loading = false;
    return resp;
  }
}
