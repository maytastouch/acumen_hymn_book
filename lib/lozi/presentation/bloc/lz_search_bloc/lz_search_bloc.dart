import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data_sources/lozi_data_source.dart';
import '../../../data/models/lozi_hymn_model.dart';

part 'lz_search_event.dart';
part 'lz_search_state.dart';

class LzSearchBloc extends Bloc<LzSearchEvent, LzSearchState> {
  List<LzHymnModel>? _allHymns;

  LzSearchBloc() : super(LzSearchInitial()) {
    on<LzSearchHymnsEvent>(_onSearchHymns);
    on<LzLoadAllHymnsEvent>(_onLoadAllHymns);
  }

  Future<List<LzHymnModel>> fetchHymnList() async {
    if (_allHymns != null) return _allHymns!;
    _allHymns = await LocalMethods.fromJsonFile('assets/hymns/lz/meta.json');
    return _allHymns!;
  }

  Future<void> _onSearchHymns(
      LzSearchHymnsEvent event, Emitter<LzSearchState> emit) async {
    emit(LzSearchLoading());
    try {
      List<LzHymnModel> allHymns = await fetchHymnList();
      List<LzHymnModel> filteredHymns = allHymns
          .where((hymn) =>
              hymn.hymnTitle
                  .toLowerCase()
                  .contains(event.query.toLowerCase()) ||
              hymn.hymnNumber.toString().contains(event.query))
          .toList();
      emit(LzSearchLoaded(hymns: filteredHymns));
    } catch (e) {
      emit(LzSearchError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadAllHymns(
      LzLoadAllHymnsEvent event, Emitter<LzSearchState> emit) async {
    emit(LzSearchInitial());
  }
}
