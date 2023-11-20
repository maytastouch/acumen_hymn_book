import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'font_event.dart';
part 'font_state.dart';

class FontBloc extends Bloc<FontEvent, FontState> {
  final int fontSize;
  FontBloc(this.fontSize) : super(FontInitial(fontSize: fontSize)) {
    on<SetFontSizeEvent>(setFontSizeEvent);
  }

  Future<void> setFontSizeEvent(
      SetFontSizeEvent event, Emitter<FontState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fontSize', event.fontSize);

    emit(FontSizeUpdated(event.fontSize));
  }

  static Future<int> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('fontSize') ?? 20; // Default to 20 if not found
  }
}
