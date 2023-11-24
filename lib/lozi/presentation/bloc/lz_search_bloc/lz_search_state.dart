part of 'lz_search_bloc.dart';

sealed class LzSearchState extends Equatable {
  const LzSearchState();

  @override
  List<Object> get props => [];
}

final class LzSearchInitial extends LzSearchState {}

class LzSearchLoading extends LzSearchState {}

class LzSearchLoaded extends LzSearchState {
  final List<LzHymnEntity> hymns;

  const LzSearchLoaded({required this.hymns});

  @override
  List<Object> get props => [hymns];
}

class LzSearchError extends LzSearchState {
  final String errorMessage;

  const LzSearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
