part of 'xh_favorite_bloc.dart';

sealed class XhFavoriteState extends Equatable {
  const XhFavoriteState();

  @override
  List<Object> get props => [];
}

final class XhFavoriteInitial extends XhFavoriteState {}

class XhFavoriteLoaded extends XhFavoriteState {
  final List<HymnModel> hymnModel;

  const XhFavoriteLoaded({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class XhFavoriteRemoved extends XhFavoriteState {
  final List<HymnModel> hymnModel;

  const XhFavoriteRemoved({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class XhFavoriteError extends XhFavoriteState {
  final String message;

  const XhFavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
