part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class SetFavoriteEvent extends FavoriteEvent {
  final HymnModel hymnModel;

  const SetFavoriteEvent({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class FetchFavoritesEvent extends FavoriteEvent {
  const FetchFavoritesEvent();

  @override
  List<Object> get props => []; // No additional properties needed
}
