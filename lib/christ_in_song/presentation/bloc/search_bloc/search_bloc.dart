import 'dart:async';

import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/local_data_source_methods.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>(searchStarted);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    // Replace with your actual logic to fetch hymn list
    return LocalMethods.readHymnsFromFile('assets/hymns/en/meta.json');
  }

  FutureOr<void> searchStarted(
      SearchEvent event, Emitter<SearchState> emit) async {
    if (event is SearchHymnsEvent) {
      emit(SearchLoading());
      try {
        List<HymnEntity> allHymns = await _fetchHymnList();
        List<HymnEntity> filteredHymns = allHymns
            .where((hymn) =>
                hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
                hymn.number.contains(event.query))
            .toList();
        emit(SearchLoaded(hymns: filteredHymns));
      } catch (e) {
        emit(SearchError(errorMessage: e.toString()));
      }
    } else if (event is LoadAllHymnsEvent) {
      emit(SearchLoading());
      try {
        List<HymnEntity> allHymns = await _fetchHymnList();
        emit(SearchLoaded(hymns: allHymns));
      } catch (e) {
        emit(SearchError(errorMessage: e.toString()));
      }
    }
  }
}
