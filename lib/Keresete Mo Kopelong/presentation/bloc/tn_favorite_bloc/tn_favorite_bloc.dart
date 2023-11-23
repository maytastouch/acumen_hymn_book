import 'dart:async';

import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tn_favorite_event.dart';
part 'tn_favorite_state.dart';

class TnFavoriteBloc extends Bloc<TnFavoriteEvent, TnFavoriteState> {
  static const String _tnFavoritesKey = 'tnFavorites';
  List<HymnModel> tnFavoriteHymns = [];

  TnFavoriteBloc() : super(TnFavoriteInitial()) {
    on<TnFavoriteEvent>(_onTnFavoriteEvent);
    _tnLoadFavorites();
  }

  FutureOr<void> _onTnFavoriteEvent(
      TnFavoriteEvent event, Emitter<TnFavoriteState> emit) {
    if (event is TnSetFavoriteEvent) {
      _tnHandleSetFavoriteEvent(event, emit);
    } else if (event is TnFetchFavoritesEvent) {
      _tnHandleFetchFavoritesEvent(emit);
    }
  }

  void _tnHandleSetFavoriteEvent(
      TnSetFavoriteEvent event, Emitter<TnFavoriteState> emit) {
    _tnToggleFavorite(event.hymnModel);
    _tnSaveFavorites();
    emit(TnFavoriteLoaded(hymnModel: tnFavoriteHymns));
  }

  void _tnHandleFetchFavoritesEvent(Emitter<TnFavoriteState> emit) {
    emit(TnFavoriteLoaded(hymnModel: tnFavoriteHymns));
  }

  _tnToggleFavorite(HymnModel hymn) {
    List<HymnModel> updatedFavorites = List.from(tnFavoriteHymns);
    if (updatedFavorites.contains(hymn)) {
      updatedFavorites.remove(hymn);
    } else {
      updatedFavorites.add(hymn);
    }
    tnFavoriteHymns = updatedFavorites;
    // Emit state here
  }

  Future<void> _tnLoadFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final tnFavoriteHymnNumbers = prefs2.getStringList(_tnFavoritesKey) ?? [];
    tnFavoriteHymns = await _tnGetHymnsByNumbers(tnFavoriteHymnNumbers);
    add(const TnFetchFavoritesEvent());
  }

  Future<void> _tnSaveFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final tnFavoriteHymnNumbers =
        tnFavoriteHymns.map((hymn) => hymn.hymnNumber.toString()).toList();
    await prefs2.setStringList(_tnFavoritesKey, tnFavoriteHymnNumbers);
  }

  Future<List<HymnModel>> _tnGetHymnsByNumbers(List<String> hymnNumbers) async {
    List<HymnModel> hymns = [];
    for (String number in hymnNumbers) {
      // Construct the file path for each hymn
      String filePath =
          'assets/hymns/tn/${number.padLeft(3, '0')}.md'; // Adjust the path format as needed
      HymnModel? hymn = await HymnModel.fromMarkdownFile(filePath);
      if (hymn != null) {
        hymns.add(hymn);
      }
    }
    return hymns;
  }
}
