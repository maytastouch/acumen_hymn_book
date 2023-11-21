import 'dart:async';

import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Future<List<HymnEntity>> searchedHymnList;
  SearchBloc(this.searchedHymnList) : super(SearchInitial()) {
    on<SearchEvent>(searchStarted);
  }

  FutureOr<void> searchStarted(
      SearchEvent event, Emitter<SearchState> emit) async {
    if (event is SearchHymnsEvent) {
      emit(SearchLoading());
      try {
        List<HymnEntity> allHymns = await searchedHymnList;
        List<HymnEntity> filteredHymns = allHymns
            .where((hymn) =>
                hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
                hymn.number.contains(event.query))
            .toList();
        emit(SearchLoaded(hymns: filteredHymns));
      } catch (e) {
        emit(SearchError(errorMessage: e.toString()));
      }
    }
  }
}
