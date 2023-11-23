part of 'xh_favorite_bloc.dart';

sealed class XhFavoriteEvent extends Equatable {
  const XhFavoriteEvent();

  @override
  List<Object> get props => [];
}

class XhSetFavoriteEvent extends XhFavoriteEvent {
  final HymnModel hymnModel;

  const XhSetFavoriteEvent({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class XhFetchFavoritesEvent extends XhFavoriteEvent {
  const XhFetchFavoritesEvent();

  @override
  List<Object> get props => []; // No additional properties needed
}
