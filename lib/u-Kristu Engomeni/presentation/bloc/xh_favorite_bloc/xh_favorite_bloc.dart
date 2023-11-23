import 'dart:async';

import 'package:acumen_hymn_book/christ_in_song/data/models/hymn_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'xh_favorite_event.dart';
part 'xh_favorite_state.dart';

class XhFavoriteBloc extends Bloc<XhFavoriteEvent, XhFavoriteState> {
  static const String _xhFavoritesKey = 'xhFavorites';
  List<HymnModel> xhFavoriteHymns = [];

  XhFavoriteBloc() : super(XhFavoriteInitial()) {
    on<XhFavoriteEvent>(_onXhFavoriteEvent);
    _xhLoadFavorites();
  }

  FutureOr<void> _onXhFavoriteEvent(
      XhFavoriteEvent event, Emitter<XhFavoriteState> emit) {
    if (event is XhSetFavoriteEvent) {
      _xhHandleSetFavoriteEvent(event, emit);
    } else if (event is XhFetchFavoritesEvent) {
      _xhHandleFetchFavoritesEvent(emit);
    }
  }

  void _xhHandleSetFavoriteEvent(
      XhSetFavoriteEvent event, Emitter<XhFavoriteState> emit) {
    _xhToggleFavorite(event.hymnModel);
    _xhSaveFavorites();
    emit(XhFavoriteLoaded(hymnModel: xhFavoriteHymns));
  }

  void _xhHandleFetchFavoritesEvent(Emitter<XhFavoriteState> emit) {
    emit(XhFavoriteLoaded(hymnModel: xhFavoriteHymns));
  }

  _xhToggleFavorite(HymnModel hymn) {
    List<HymnModel> updatedFavorites = List.from(xhFavoriteHymns);
    if (updatedFavorites.contains(hymn)) {
      updatedFavorites.remove(hymn);
    } else {
      updatedFavorites.add(hymn);
    }
    xhFavoriteHymns = updatedFavorites;
    // Emit state here
  }

  Future<void> _xhLoadFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final xhFavoriteHymnNumbers = prefs2.getStringList(_xhFavoritesKey) ?? [];
    xhFavoriteHymns = await _xhGetHymnsByNumbers(xhFavoriteHymnNumbers);
    add(const XhFetchFavoritesEvent());
  }

  Future<void> _xhSaveFavorites() async {
    final prefs2 = await SharedPreferences.getInstance();
    final xhFavoriteHymnNumbers =
        xhFavoriteHymns.map((hymn) => hymn.hymnNumber.toString()).toList();
    await prefs2.setStringList(_xhFavoritesKey, xhFavoriteHymnNumbers);
  }

  Future<List<HymnModel>> _xhGetHymnsByNumbers(List<String> hymnNumbers) async {
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
