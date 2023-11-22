import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(themeData: appThemeData[AppTheme.LightTheme]!)) {
    _loadTheme();

    on<ThemeEvent>((event, emit) async {
      if (event is ThemeChanged) {
        await _saveTheme(event.theme);
        emit.call(ThemeState(themeData: appThemeData[event.theme]!));
      }
    });
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme') ?? AppTheme.LightTheme.index;
    final theme = AppTheme.values[themeIndex];
    add(ThemeChanged(theme: theme));
  }

  Future<void> _saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme', theme.index);
  }
}
