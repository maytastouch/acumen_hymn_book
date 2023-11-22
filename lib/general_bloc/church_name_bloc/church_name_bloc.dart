import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'church_name_event.dart';
part 'church_name_state.dart';

class ChurchNameBloc extends Bloc<ChurchNameEvent, ChurchNameState> {
  ChurchNameBloc() : super(ChurchNameInitial()) {
    on<ChurchNameEvent>(nameChangeEntered);
  }

  FutureOr<void> nameChangeEntered(
      ChurchNameEvent event, Emitter<ChurchNameState> emit) {
    if (event is NamedChangedEvent) {
      emit(NameChanged(churchName: event.churchName));
    }
  }
}
