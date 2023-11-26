part of 'sda_search_bloc.dart';

sealed class SDASearchEvent extends Equatable {
  const SDASearchEvent();

  @override
  List<Object> get props => [];
}

class SDASearchHymnsEvent extends SDASearchEvent {
  final String query;

  const SDASearchHymnsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class SDALoadAllHymnsEvent extends SDASearchEvent {}
