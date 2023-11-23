part of 'xh_search_bloc.dart';

sealed class XhSearchState extends Equatable {
  const XhSearchState();

  @override
  List<Object> get props => [];
}

final class XhSearchInitial extends XhSearchState {}

class XhSearchLoading extends XhSearchState {}

class XhSearchLoaded extends XhSearchState {
  final List<HymnEntity> hymns;

  const XhSearchLoaded({required this.hymns});

  @override
  List<Object> get props => [hymns];
}

class XhSearchError extends XhSearchState {
  final String errorMessage;

  const XhSearchError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
