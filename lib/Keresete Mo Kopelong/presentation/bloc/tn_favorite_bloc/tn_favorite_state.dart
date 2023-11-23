part of 'tn_favorite_bloc.dart';

sealed class TnFavoriteState extends Equatable {
  const TnFavoriteState();

  @override
  List<Object> get props => [];
}

final class TnFavoriteInitial extends TnFavoriteState {}

class TnFavoriteLoaded extends TnFavoriteState {
  final List<HymnModel> hymnModel;

  const TnFavoriteLoaded({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class TnFavoriteRemoved extends TnFavoriteState {
  final List<HymnModel> hymnModel;

  const TnFavoriteRemoved({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class TnFavoriteError extends TnFavoriteState {
  final String message;

  const TnFavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
