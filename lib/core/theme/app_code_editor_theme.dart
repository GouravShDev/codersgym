import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:flutter_highlight/themes/nord.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';

class AppCodeEditorTheme {
  final String id;
  final Map<String, TextStyle> data;

  AppCodeEditorTheme({
    required this.id,
    required this.data,
  });

  static String defaultThemeId = 'monokai';
  // List of themes using the AppCodeEditorTheme model
  static List<AppCodeEditorTheme> allCodeEditorThemes = [
    AppCodeEditorTheme(
      id: 'atom-one-dark',
      data: atomOneDarkTheme,
    ),
    AppCodeEditorTheme(
      id: 'darcula',
      data: darculaTheme,
    ),
    AppCodeEditorTheme(
      id: 'dracula',
      data: draculaTheme,
    ),
    AppCodeEditorTheme(
      id: 'monokai',
      data: monokaiTheme,
    ),
    AppCodeEditorTheme(
      id: 'nord',
      data: nordTheme,
    ),
    AppCodeEditorTheme(
      id: 'night-owl',
      data: nightOwlTheme,
    ),
    AppCodeEditorTheme(
      id: 'solarized-dark',
      data: solarizedDarkTheme,
    ),
  ];
}
