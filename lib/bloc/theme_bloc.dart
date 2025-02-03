import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme.dart';

// Theme Events
abstract class ThemeEvent {}

class SetLightTheme extends ThemeEvent {}

class SetDarkTheme extends ThemeEvent {}

class SetCustomTheme extends ThemeEvent {} // Optional for custom themes

// Theme States
abstract class ThemeState {
  final ThemeMode themeMode;
  final ThemeData? customTheme;

  const ThemeState(this.themeMode, {this.customTheme});
}

class LightThemeState extends ThemeState {
  LightThemeState() : super(ThemeMode.light);
}

class DarkThemeState extends ThemeState {
  DarkThemeState() : super(ThemeMode.dark);
}

class CustomThemeState extends ThemeState {
  CustomThemeState(ThemeData customTheme)
      : super(ThemeMode.light, customTheme: customTheme);
}

// ThemeBloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(LightThemeState()) {
    on<SetLightTheme>((event, emit) => emit(LightThemeState()));
    on<SetDarkTheme>((event, emit) => emit(DarkThemeState()));
    on<SetCustomTheme>((event, emit) => emit(CustomThemeState(customTheme)));
  }
}
