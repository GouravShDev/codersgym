import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:flutter_highlight/themes/nord.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/xcode.dart';

class AppCodeEditorField extends StatelessWidget {
  const AppCodeEditorField({
    super.key,
    required this.codeController,
    this.enabled,
    required this.editorThemeId,
  });
  final CodeController codeController;
  final String? editorThemeId;
  final bool? enabled;

  // List of themes using the AppCodeEditorTheme model
  static List<AppCodeEditorTheme> codeEditorThemes = [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CodeTheme(
      data:
          CodeThemeData(styles: themeMap[editorThemeId] ?? monokaiSublimeTheme),
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor:
                //  themeMap[editorThemeId]?['root']?.backgroundColor ??
                theme.scaffoldBackgroundColor,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
        child: CodeField(
          controller: codeController,
          expands: false,
          wrap: true,
          enabled: enabled,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          background:
              // themeMap[editorThemeId]?['root']?.backgroundColor ??
              theme.scaffoldBackgroundColor,
          gutterStyle: GutterStyle(
            width: 44,
            showFoldingHandles: true,
            showErrors: false,
            textAlign: TextAlign.right,
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                  height: 1.46,
                ),
            margin: 2,
            background:
                // themeMap[editorThemeId]?['root']?.backgroundColor ??
                theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}

class AppCodeEditorTheme {
  final String id;
  final Map<String, TextStyle> data;

  AppCodeEditorTheme({
    required this.id,
    required this.data,
  });
}
