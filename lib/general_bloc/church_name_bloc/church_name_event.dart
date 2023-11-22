part of 'church_name_bloc.dart';

sealed class ChurchNameEvent extends Equatable {
  const ChurchNameEvent();

  @override
  List<Object> get props => [];
}

class NamedChangedEvent extends ChurchNameEvent {
  final String churchName;

  const NamedChangedEvent({required this.churchName});

  @override
  List<Object> get props => [churchName];
}
