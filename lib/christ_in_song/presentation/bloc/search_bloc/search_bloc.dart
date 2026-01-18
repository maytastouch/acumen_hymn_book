import 'dart:async';

import 'package:acumen_hymn_book/christ_in_song/domain/entity/hymn_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/local_data_source_methods.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  List<HymnEntity>? _allHymns;

  SearchBloc() : super(SearchInitial()) {
    on<SearchHymnsEvent>(_onSearchHymns);
    on<LoadAllHymnsEvent>(_onLoadAllHymns);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    if (_allHymns != null) return _allHymns!;
    _allHymns = await LocalMethods.readHymnsFromFile('assets/hymns/en/meta.json');
    return _allHymns!;
  }

  Future<void> _onSearchHymns(
      SearchHymnsEvent event, Emitter<SearchState> emit) async {
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
  }

  Future<void> _onLoadAllHymns(
      LoadAllHymnsEvent event, Emitter<SearchState> emit) async {
    emit(SearchInitial());
  }
}
