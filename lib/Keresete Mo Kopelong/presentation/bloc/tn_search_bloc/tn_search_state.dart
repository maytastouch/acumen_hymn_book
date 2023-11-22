part of 'tn_search_bloc.dart';

sealed class TnSearchState extends Equatable {
  const TnSearchState();

  @override
  List<Object> get props => [];
}

final class TnSearchInitial extends TnSearchState {}

class TnSearchLoading extends TnSearchState {}

class TnSearchLoaded extends TnSearchState {
  final List<HymnEntity> hymns;

  const TnSearchLoaded({required this.hymns});

  @override
  List<Object> get props => [hymns];
}

class TnSearchError extends TnSearchState {
  final String errorMessage;

  const TnSearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
