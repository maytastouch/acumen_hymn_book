part of 'lz_favorite_bloc.dart';

sealed class LzFavoriteState extends Equatable {
  const LzFavoriteState();

  @override
  List<Object> get props => [];
}

final class LzFavoriteInitial extends LzFavoriteState {}

class LzFavoriteLoaded extends LzFavoriteState {
  final List<LzHymnModel> hymnModel;

  const LzFavoriteLoaded({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class LzFavoriteRemoved extends LzFavoriteState {
  final List<LzHymnModel> hymnModel;

  const LzFavoriteRemoved({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class LzFavoriteError extends LzFavoriteState {
  final String message;

  const LzFavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
