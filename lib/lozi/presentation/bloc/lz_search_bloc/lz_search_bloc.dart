import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data_sources/lozi_data_source.dart';
import '../../../domain/lz_hymn_entity.dart';

part 'lz_search_event.dart';
part 'lz_search_state.dart';

class LzSearchBloc extends Bloc<LzSearchEvent, LzSearchState> {
  LzSearchBloc() : super(LzSearchInitial()) {
    on<LzSearchEvent>(searchStarted);
  }

  Future<List<LzHymnEntity>> fetchHymnList() async {
    // Replace with your actual logic to fetch hymn list
    // For example:
    return LzLocalMethods.readHymnsFromFile('assets/hymns/lz/meta.json');
  }

  FutureOr<void> searchStarted(
      LzSearchEvent event, Emitter<LzSearchState> emit) async {
    if (event is LzSearchHymnsEvent) {
      emit(LzSearchLoading());
      try {
        List<LzHymnEntity> allHymns = await fetchHymnList();
        List<LzHymnEntity> filteredHymns = allHymns
            .where((hymn) =>
                hymn.title.toLowerCase().contains(event.query.toLowerCase()) ||
                hymn.number.contains(event.query))
            .toList();
        emit(LzSearchLoaded(hymns: filteredHymns));
      } catch (e) {
        emit(LzSearchError(errorMessage: e.toString()));
      }
    } else if (event is LzLoadAllHymnsEvent) {
      emit(LzSearchLoading());
      try {
        List<LzHymnEntity> allHymns = await fetchHymnList();
        emit(LzSearchLoaded(hymns: allHymns));
      } catch (e) {
        emit(LzSearchError(errorMessage: e.toString()));
      }
    }
    return null;
  }
}
