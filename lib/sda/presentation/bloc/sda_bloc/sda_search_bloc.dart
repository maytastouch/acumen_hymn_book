import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/datasource/sda_data_source.dart';
import '../../../data/models/sda_hymn_model.dart';

part 'sda_search_event.dart';
part 'sda_search_state.dart';

class SDASearchBloc extends Bloc<SDASearchEvent, SDASearchState> {
  List<SDAHymnModel>? _allHymns;

  SDASearchBloc() : super(SDASearchInitial()) {
    on<SDASearchHymnsEvent>(_onSearchHymns);
    on<SDALoadAllHymnsEvent>(_onLoadAllHymns);
  }

  Future<List<SDAHymnModel>> fetchHymnList() async {
    if (_allHymns != null) return _allHymns!;
    _allHymns = await SDALocalMethods.fromJsonFile('assets/hymns/sda/meta.json');
    return _allHymns!;
  }

  Future<void> _onSearchHymns(
      SDASearchHymnsEvent event, Emitter<SDASearchState> emit) async {
    emit(SDASearchLoading());
    try {
      List<SDAHymnModel> allHymns = await fetchHymnList();
      List<SDAHymnModel> filteredHymns = allHymns
          .where((hymn) =>
              hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
              hymn.number.contains(event.query))
          .toList();
      emit(SDASearchLoaded(hymns: filteredHymns));
    } catch (e) {
      emit(SDASearchError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadAllHymns(
      SDALoadAllHymnsEvent event, Emitter<SDASearchState> emit) async {
    emit(SDASearchInitial());
  }
}
