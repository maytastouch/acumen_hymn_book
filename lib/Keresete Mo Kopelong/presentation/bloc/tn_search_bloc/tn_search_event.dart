part of 'tn_search_bloc.dart';

sealed class TnSearchEvent extends Equatable {
  const TnSearchEvent();

  @override
  List<Object> get props => [];
}

class TnSearchHymnsEvent extends TnSearchEvent {
  final String query;

  const TnSearchHymnsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class TnLoadAllHymnsEvent extends TnSearchEvent {}
