import 'dart:async';

import 'package:acumen_hymn_book/Keresete%20Mo%20Kopelong/data/datasources/tn_local_data_source.dart';
import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tn_search_event.dart';
part 'tn_search_state.dart';

class TnSearchBloc extends Bloc<TnSearchEvent, TnSearchState> {
  TnSearchBloc() : super(TnSearchInitial()) {
    on<TnSearchEvent>(searchStarted);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    // Replace with your actual logic to fetch hymn list
    // For example:
    return TnLocalMethods.readHymnsFromFile('assets/hymns/tn/meta.json');
  }

  FutureOr<void> searchStarted(
      TnSearchEvent event, Emitter<TnSearchState> emit) async {
    if (event is TnSearchHymnsEvent) {
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
    } else if (event is TnLoadAllHymnsEvent) {
      emit(TnSearchLoading());
      try {
        List<HymnEntity> allHymns = await _fetchHymnList();
        emit(TnSearchLoaded(hymns: allHymns));
      } catch (e) {
        emit(TnSearchError(errorMessage: e.toString()));
      }
    }
  }
}
