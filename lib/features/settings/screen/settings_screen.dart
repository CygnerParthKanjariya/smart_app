import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/settings/bloc/settings_bloc.dart';

import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, state) {
          bool isDarkMode = false;
          if (state is SettingsThemeState) {
            isDarkMode = state.themeData.brightness == Brightness.dark;
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Theme"),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(
                          ChangeThemeSettingsEvent(
                            themeData: value ? ThemeData.light() : ThemeData.dark(),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
