part of 'lz_search_bloc.dart';

sealed class LzSearchEvent extends Equatable {
  const LzSearchEvent();

  @override
  List<Object> get props => [];
}

class LzSearchHymnsEvent extends LzSearchEvent {
  final String query;

  const LzSearchHymnsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LzLoadAllHymnsEvent extends LzSearchEvent {}
