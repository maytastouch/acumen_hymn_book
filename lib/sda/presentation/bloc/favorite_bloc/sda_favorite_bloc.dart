import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/datasource/sda_data_source.dart';
import '../../../data/models/sda_hymn_model.dart';

part 'sda_favorite_event.dart';
part 'sda_favorite_state.dart';

class SDAFavoriteBloc extends Bloc<SDAFavoriteEvent, SDAFavoriteState> {
  static const String _sdaFavoritesKey = 'sdaFavorites';
  List<SDAHymnModel> sdaFavoriteHymns = [];

  SDAFavoriteBloc() : super(SDAFavoriteInitial()) {
    on<SDAFavoriteEvent>(_onSDAFavoriteEvent);
    _sdaLoadFavorites();
  }

  // Event Handlers
  FutureOr<void> _onSDAFavoriteEvent(
      SDAFavoriteEvent event, Emitter<SDAFavoriteState> emit) async {
    if (event is SDASetFavoriteEvent) {
      _sdaToggleFavorite(event.hymnModel, emit);
      await _sdaSaveFavorites();
    } else if (event is SDAFetchFavoritesEvent) {
      emit(SDAFavoriteLoaded(hymnModel: sdaFavoriteHymns));
    }
  }

  // Favorite Logic
  void _sdaToggleFavorite(SDAHymnModel hymn, Emitter<SDAFavoriteState> emit) {
    if (sdaFavoriteHymns.any((favorite) => favorite.number == hymn.number)) {
      sdaFavoriteHymns
          .removeWhere((favorite) => favorite.number == hymn.number);
    } else {
      sdaFavoriteHymns.add(hymn);
    }

    // Force a state update by emitting an intermediate state
    emit(SDAFavoriteLoading()); // A temporary loading state
    emit(SDAFavoriteLoaded(hymnModel: sdaFavoriteHymns));
  }

  // Shared Preferences Operations
  Future<void> _sdaLoadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHymnNumbers = prefs.getStringList(_sdaFavoritesKey) ?? [];
    sdaFavoriteHymns = await _getHymnsByNumbers(favoriteHymnNumbers);
    add(const SDAFetchFavoritesEvent());
  }

  Future<void> _sdaSaveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteHymnNumbers =
        sdaFavoriteHymns.map((hymn) => hymn.number).toList();
    await prefs.setStringList(_sdaFavoritesKey, favoriteHymnNumbers);
  }

  // Fetch Hymns by Numbers
  Future<List<SDAHymnModel>> _getHymnsByNumbers(
      List<String> hymnNumbers) async {
    List<SDAHymnModel> allHymns =
        await SDALocalMethods.fromJsonFile('assets/hymns/sda/hymns.json');
    return allHymns.where((hymn) => hymnNumbers.contains(hymn.number)).toList();
  }
}
