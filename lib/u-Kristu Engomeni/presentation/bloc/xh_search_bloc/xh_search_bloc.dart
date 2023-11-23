import 'dart:async';

import 'package:acumen_hymn_book/u-Kristu%20Engomeni/data/datasource/xh_local_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../christ_in_song/domain/entity/hymn_entity.dart';

part 'xh_search_event.dart';
part 'xh_search_state.dart';

class XhSearchBloc extends Bloc<XhSearchEvent, XhSearchState> {
  XhSearchBloc() : super(XhSearchInitial()) {
    on<XhSearchEvent>(searchStarted);
  }

  Future<List<HymnEntity>> _fetchHymnList() async {
    // Replace with your actual logic to fetch hymn list
    // For example:
    return LocalMethods.readHymnsFromFile('assets/hymns/tn/meta.json');
  }

  FutureOr<void> searchStarted(
      XhSearchEvent event, Emitter<XhSearchState> emit) async {
    if (event is XhSearchHymnsEvent) {
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
    } else if (event is XhLoadAllHymnsEvent) {
      emit(XhSearchLoading());
      try {
        List<HymnEntity> allHymns = await _fetchHymnList();
        emit(XhSearchLoaded(hymns: allHymns));
      } catch (e) {
        emit(XhSearchError(errorMessage: e.toString()));
      }
    }
  }
}
