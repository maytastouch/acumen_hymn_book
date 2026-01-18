import 'dart:async';

import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/data/datasources/tn_local_data_source.dart';
import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tn_search_event.dart';
part 'tn_search_state.dart';

class TnSearchBloc extends Bloc<TnSearchEvent, TnSearchState> {
  List<HymnEntity>? _allHymns;

  TnSearchBloc() : super(TnSearchInitial()) {
    on<TnSearchHymnsEvent>(_onSearchHymns);
    on<TnLoadAllHymnsEvent>(_onLoadAllHymns);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    if (_allHymns != null) return _allHymns!;
    _allHymns = await TnLocalMethods.readHymnsFromFile('assets/hymns/tn/meta.json');
    return _allHymns!;
  }

  Future<void> _onSearchHymns(
      TnSearchHymnsEvent event, Emitter<TnSearchState> emit) async {
    emit(TnSearchLoading());
    try {
      List<HymnEntity> allHymns = await _fetchHymnList();
      List<HymnEntity> filteredHymns = allHymns
          .where((hymn) =>
              hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
              hymn.number.contains(event.query))
          .toList();
      emit(TnSearchLoaded(hymns: filteredHymns));
    } catch (e) {
      emit(TnSearchError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadAllHymns(
      TnLoadAllHymnsEvent event, Emitter<TnSearchState> emit) async {
    // Emit initial state to revert to TnHymnListWidget which has its own caching and state
    emit(TnSearchInitial());
  }
}
