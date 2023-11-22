import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../christ_in_song/domain/entity/hymn_entity.dart';

part 'tn_search_event.dart';
part 'tn_search_state.dart';

class TnSearchBloc extends Bloc<TnSearchEvent, TnSearchState> {
  final Future<List<HymnEntity>> searchedHymnList;
  TnSearchBloc(this.searchedHymnList) : super(TnSearchInitial()) {
    on<TnSearchEvent>(searchStarted);
  }

  FutureOr<void> searchStarted(
      TnSearchEvent event, Emitter<TnSearchState> emit) async {
    if (event is TnSearchHymnsEvent) {
      emit(TnSearchLoading());
      try {
        List<HymnEntity> allHymns = await searchedHymnList;
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
        List<HymnEntity> allHymns = await searchedHymnList;
        emit(TnSearchLoaded(hymns: allHymns));
      } catch (e) {
        emit(TnSearchError(errorMessage: e.toString()));
      }
    }
  }
}
