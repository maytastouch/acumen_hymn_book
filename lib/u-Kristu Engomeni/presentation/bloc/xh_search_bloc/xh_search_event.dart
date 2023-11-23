part of 'xh_search_bloc.dart';

sealed class XhSearchEvent extends Equatable {
  const XhSearchEvent();

  @override
  List<Object> get props => [];
}

class XhSearchHymnsEvent extends XhSearchEvent {
  final String query;

  const XhSearchHymnsEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class XhLoadAllHymnsEvent extends XhSearchEvent {}
