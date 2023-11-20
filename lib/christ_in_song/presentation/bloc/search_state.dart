part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<HymnEntity> hymns;

  const SearchLoaded({required this.hymns});

  @override
  List<Object> get props => [hymns];
}

class SearchError extends SearchState {
  final String errorMessage;

  const SearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
