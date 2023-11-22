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

  _toggleFavorite(HymnModel hymn) {
    List<HymnModel> updatedFavorites = List.from(favoriteHymns);
    if (updatedFavorites.contains(hymn)) {
      updatedFavorites.remove(hymn);
    } else {
      updatedFavorites.add(hymn);
    }
    favoriteHymns = updatedFavorites;
    // Emit state here
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
        favoriteHymns.map((hymn) => hymn.hymnNumber.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteHymnNumbers);
    // Debugging line:
    print("Saved favorites: ${prefs.getStringList(_favoritesKey)}");
  }

  Future<List<HymnModel>> _getHymnsByNumbers(List<String> hymnNumbers) async {
    List<HymnModel> hymns = [];
    for (String number in hymnNumbers) {
      // Construct the file path for each hymn
      String filePath =
          'assets/hymns/en/${number.padLeft(3, '0')}.md'; // Adjust the path format as needed
      HymnModel? hymn = await HymnModel.fromMarkdownFile(filePath);
      if (hymn != null) {
        hymns.add(hymn);
      }
    }
    return hymns;
  }
}
//assets/hymns/en