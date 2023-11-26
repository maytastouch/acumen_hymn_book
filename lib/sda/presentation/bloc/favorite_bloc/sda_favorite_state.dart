part of 'sda_favorite_bloc.dart';

sealed class SDAFavoriteState extends Equatable {
  const SDAFavoriteState();

  @override
  List<Object> get props => [];
}

final class SdaFavoriteInitial extends SDAFavoriteState {}

final class SDAFavoriteInitial extends SDAFavoriteState {}

class SDAFavoriteLoading extends SDAFavoriteState {}

class SDAFavoriteLoaded extends SDAFavoriteState {
  final List<SDAHymnModel> hymnModel;

  const SDAFavoriteLoaded({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class SDAFavoriteRemoved extends SDAFavoriteState {
  final List<SDAHymnModel> hymnModel;

  const SDAFavoriteRemoved({required this.hymnModel});

  @override
  List<Object> get props => [hymnModel];
}

class SDAFavoriteError extends SDAFavoriteState {
  final String message;

  const SDAFavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
