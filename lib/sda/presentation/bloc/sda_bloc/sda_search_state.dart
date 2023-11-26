part of 'sda_search_bloc.dart';

sealed class SDASearchState extends Equatable {
  const SDASearchState();

  @override
  List<Object> get props => [];
}

final class SDASearchInitial extends SDASearchState {}

class SDASearchLoading extends SDASearchState {}

class SDASearchLoaded extends SDASearchState {
  final List<SDAHymnModel> hymns;

  const SDASearchLoaded({required this.hymns});

  @override
  List<Object> get props => [hymns];
}

class SDASearchError extends SDASearchState {
  final String errorMessage;

  const SDASearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
