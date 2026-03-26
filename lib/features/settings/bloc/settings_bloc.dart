import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/settings/bloc/settings_event.dart';
import 'package:smart_grocery/features/settings/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsThemeState(themeData: ThemeData.light())) {
    on<ChangeThemeSettingsEvent>((event, emit) {
      bool isDark = event.themeData.brightness == Brightness.dark;
      emit(
        SettingsThemeState(
          themeData: isDark ? ThemeData.light() : ThemeData.dark(),
        ),
      );
    });
  }
}
