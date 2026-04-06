
import 'package:flutter/material.dart';

abstract class SettingsEvent {}

class ChangeThemeSettingsEvent extends SettingsEvent{
  final ThemeData themeData;

  ChangeThemeSettingsEvent({required this.themeData});
}

class LoadThemeEvent extends SettingsEvent {}