part of 'sda_favorite_bloc.dart';

sealed class SDAFavoriteEvent extends Equatable {
  const SDAFavoriteEvent();

  @override
  List<Object> get props => [];
}

class SDASetFavoriteEvent extends SDAFavoriteEvent {
  final SDAHymnModel hymnModel;

  const SDASetFavoriteEvent({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class SDAFetchFavoritesEvent extends SDAFavoriteEvent {
  const SDAFetchFavoritesEvent();

  @override
  List<Object> get props => []; // No additional properties needed
}
