import 'package:flutter/material.dart';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}


class SettingsThemeState extends SettingsState{
  final ThemeData themeData;

  SettingsThemeState({required this.themeData});
}