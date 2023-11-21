part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<HymnModel> hymnModel;

  const FavoriteLoaded({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class FavoriteRemoved extends FavoriteState {
  final List<HymnModel> hymnModel;

  const FavoriteRemoved({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
