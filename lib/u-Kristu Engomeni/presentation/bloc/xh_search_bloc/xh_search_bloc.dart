import 'dart:async';

import 'package:acumen_hymn_book/u-Kristu%20Engomeni/data/datasource/xh_local_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../christ_in_song/domain/entity/hymn_entity.dart';

part 'xh_search_event.dart';
part 'xh_search_state.dart';

class XhSearchBloc extends Bloc<XhSearchEvent, XhSearchState> {
  List<HymnEntity>? _allHymns;

  XhSearchBloc() : super(XhSearchInitial()) {
    on<XhSearchHymnsEvent>(_onSearchHymns);
    on<XhLoadAllHymnsEvent>(_onLoadAllHymns);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    if (_allHymns != null) return _allHymns!;
    _allHymns = await LocalMethods.readHymnsFromFile('assets/hymns/xh/meta.json');
    return _allHymns!;
  }

  Future<void> _onSearchHymns(
      XhSearchHymnsEvent event, Emitter<XhSearchState> emit) async {
    emit(XhSearchLoading());
    try {
      List<HymnEntity> allHymns = await _fetchHymnList();
      List<HymnEntity> filteredHymns = allHymns
          .where((hymn) =>
              hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
              hymn.number.contains(event.query))
          .toList();
      emit(XhSearchLoaded(hymns: filteredHymns));
    } catch (e) {
      emit(XhSearchError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadAllHymns(
      XhLoadAllHymnsEvent event, Emitter<XhSearchState> emit) async {
    emit(XhSearchInitial());
  }
}
