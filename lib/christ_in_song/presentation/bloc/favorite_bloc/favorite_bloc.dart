import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/hymn_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  static const String _favoritesKey = 'favorites';
  List<HymnModel> favoriteHymns = [];

  FavoriteBloc() : super(FavoriteInitial()) {
    on<FavoriteEvent>(_onFavoriteEvent);
    _loadFavorites();
  }

  FutureOr<void> _onFavoriteEvent(
      FavoriteEvent event, Emitter<FavoriteState> emit) {
    if (event is SetFavoriteEvent) {
      _handleSetFavoriteEvent(event, emit);
    } else if (event is FetchFavoritesEvent) {
      _handleFetchFavoritesEvent(emit);
    }
  }

  void _handleSetFavoriteEvent(
      SetFavoriteEvent event, Emitter<FavoriteState> emit) {
    _toggleFavorite(event.hymnModel);
    _saveFavorites();
    emit(FavoriteLoaded(hymnModel: favoriteHymns));
  }

  void _handleFetchFavoritesEvent(Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(hymnModel: favoriteHymns));
  }

  void _toggleFavorite(HymnModel hymn) {
    if (favoriteHymns.contains(hymn)) {
      favoriteHymns.remove(hymn);
    } else {
      favoriteHymns.add(hymn);
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHymnNumbers = prefs.getStringList(_favoritesKey) ?? [];
    favoriteHymns = await _getHymnsByNumbers(favoriteHymnNumbers);
    add(const FetchFavoritesEvent());
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHymnNumbers =
        favoriteHymns.map((hymn) => hymn.hymnNumber).toList();
    await prefs.setStringList(
        _favoritesKey, favoriteHymnNumbers.cast<String>());
  }

  Future<List<HymnModel>> _getHymnsByNumbers(List<String> hymnNumbers) async {
    // Implement the logic to fetch hymns by their hymn numbers.
    // This could involve querying a local database, reading from a file, etc.
    // For demonstration purposes, let's return an empty list.
    return [];
  }
}
