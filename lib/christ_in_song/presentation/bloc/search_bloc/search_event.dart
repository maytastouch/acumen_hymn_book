part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchHymnsEvent extends SearchEvent {
  final String query;

  const SearchHymnsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class LoadAllHymnsEvent extends SearchEvent {}
