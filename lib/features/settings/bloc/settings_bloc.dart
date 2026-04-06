import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_grocery/features/settings/bloc/settings_event.dart';
import 'package:smart_grocery/features/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsThemeState(themeData: ThemeData.light())) {

    on<LoadThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();

      final isDark = prefs.getBool('isDarkMode') ?? false;

      emit(
        SettingsThemeState(
          themeData: isDark ? ThemeData.dark() : ThemeData.light(),
        ),
      );
    });
    on<ChangeThemeSettingsEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();

      final isDark = event.themeData.brightness == Brightness.dark;

      await prefs.setBool('isDarkMode', isDark);

      emit(
        SettingsThemeState(
          themeData: isDark ? ThemeData.dark() : ThemeData.light(),
        ),
      );
    });
  }
}
