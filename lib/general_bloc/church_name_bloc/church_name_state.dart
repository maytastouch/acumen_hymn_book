part of 'church_name_bloc.dart';

sealed class ChurchNameState extends Equatable {
  const ChurchNameState();

  @override
  List<Object> get props => [];
}

final class ChurchNameInitial extends ChurchNameState {}

class NameChanged extends ChurchNameState {
  final String churchName;

  const NameChanged({required this.churchName});

  @override
  List<Object> get props => [churchName];
}
