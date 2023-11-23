part of 'tn_favorite_bloc.dart';

sealed class TnFavoriteEvent extends Equatable {
  const TnFavoriteEvent();

  @override
  List<Object> get props => [];
}

class TnSetFavoriteEvent extends TnFavoriteEvent {
  final HymnModel hymnModel;

  const TnSetFavoriteEvent({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class TnFetchFavoritesEvent extends TnFavoriteEvent {
  const TnFetchFavoritesEvent();

  @override
  List<Object> get props => []; // No additional properties needed
}
