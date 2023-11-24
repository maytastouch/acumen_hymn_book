part of 'lz_favorite_bloc.dart';

sealed class LzFavoriteEvent extends Equatable {
  const LzFavoriteEvent();

  @override
  List<Object> get props => [];
}

class LzSetFavoriteEvent extends LzFavoriteEvent {
  final LzHymnModel hymnModel;

  const LzSetFavoriteEvent({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class LzFetchFavoritesEvent extends LzFavoriteEvent {
  const LzFetchFavoritesEvent();

  @override
  List<Object> get props => []; // No additional properties needed
}
