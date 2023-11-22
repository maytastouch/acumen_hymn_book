import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'church_name_event.dart';
part 'church_name_state.dart';

class ChurchNameBloc extends Bloc<ChurchNameEvent, ChurchNameState> {
  ChurchNameBloc() : super(const NameChanged(churchName: "Enter Church Name")) {
    _loadChurchName();
    on<ChurchNameEvent>(nameChangeEntered);
  }

  FutureOr<void> nameChangeEntered(
      ChurchNameEvent event, Emitter<ChurchNameState> emit) async {
    if (event is NamedChangedEvent) {
      await _saveChurchName(event.churchName);
      emit(NameChanged(churchName: event.churchName));
    }
  }

  Future<void> _loadChurchName() async {
    final prefs = await SharedPreferences.getInstance();
    final churchName = prefs.getString('churchName') ?? "Enter Church Name";
    add(NamedChangedEvent(churchName: churchName));
  }

  Future<void> _saveChurchName(String churchName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('churchName', churchName);
  }
}
