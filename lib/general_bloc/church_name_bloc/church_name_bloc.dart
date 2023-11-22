import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'church_name_event.dart';
part 'church_name_state.dart';

class ChurchNameBloc extends Bloc<ChurchNameEvent, ChurchNameState> {
  ChurchNameBloc() : super(ChurchNameInitial()) {
    on<ChurchNameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
