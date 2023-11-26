import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/lozi_hymn_model.dart';

part 'lz_favorite_event.dart';
part 'lz_favorite_state.dart';

class LzFavoriteBloc extends Bloc<LzFavoriteEvent, LzFavoriteState> {
  static const String _lzFavoritesKey = 'lzFavorites';
  List<LzHymnModel> lzFavoriteHymns = [];
  LzFavoriteBloc() : super(LzFavoriteInitial()) {
    on<LzFavoriteEvent>(_onLzFavoriteEvent);

    _lzLoadFavorites();
  }

  FutureOr<void> _onLzFavoriteEvent(
      LzFavoriteEvent event, Emitter<LzFavoriteState> emit) {
    if (event is LzSetFavoriteEvent) {
      _lzHandleSetFavoriteEvent(event, emit);
    } else if (event is LzFetchFavoritesEvent) {
      _lzHandleFetchFavoritesEvent(emit);
    }
  }

  void _lzHandleSetFavoriteEvent(
      LzSetFavoriteEvent event, Emitter<LzFavoriteState> emit) {
    _lzToggleFavorite(event.hymnModel);
    _lzSaveFavorites();
    emit(LzFavoriteLoaded(hymnModel: lzFavoriteHymns));
  }

  void _lzHandleFetchFavoritesEvent(Emitter<LzFavoriteState> emit) {
    emit(LzFavoriteLoaded(hymnModel: lzFavoriteHymns));
  }

  _lzToggleFavorite(LzHymnModel hymn) {
    List<LzHymnModel> updatedFavorites = List.from(lzFavoriteHymns);
    if (updatedFavorites.contains(hymn)) {
      updatedFavorites.remove(hymn);
    } else {
      updatedFavorites.add(hymn);
    }
    lzFavoriteHymns = updatedFavorites;
    // Emit state here
  }

  Future<void> _lzLoadFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final tnFavoriteHymnNumbers = prefs2.getStringList(_lzFavoritesKey) ?? [];
    lzFavoriteHymns = await _tnGetHymnsByNumbers(tnFavoriteHymnNumbers);
    add(const LzFetchFavoritesEvent());
  }

  Future<void> _lzSaveFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final tnFavoriteHymnNumbers =
        lzFavoriteHymns.map((hymn) => hymn.hymnNumber.toString()).toList();
    await prefs2.setStringList(_lzFavoritesKey, tnFavoriteHymnNumbers);
  }

  Future<List<LzHymnModel>> _tnGetHymnsByNumbers(
      List<String> hymnNumbers) async {
    List<LzHymnModel> hymns = [];
    for (String number in hymnNumbers) {
      // Construct the file path for each hymn
      String filePath =
          'assets/hymns/lz/$number.md'; // Adjust the path format as needed
      LzHymnModel? hymn = await LzHymnModel.fromMarkdownFile(filePath);
      if (hymn != null) {
        hymns.add(hymn);
      }
    }
    return hymns;
  }
}
