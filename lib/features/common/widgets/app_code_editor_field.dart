import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class AppCodeEditorField extends StatelessWidget {
  const AppCodeEditorField({
    super.key,
    required this.codeController,
    this.enabled,
    required this.editorThemeId,
    this.focusNode,
    this.pickBackgroundFromTheme = false,
  });
  final CodeController codeController;
  final String? editorThemeId;
  final bool? enabled;
  final FocusNode? focusNode;
  final bool pickBackgroundFromTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CodeTheme(
      data:
          CodeThemeData(styles: themeMap[editorThemeId] ?? monokaiSublimeTheme),
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor: pickBackgroundFromTheme
                ? (themeMap[editorThemeId]?['root']?.backgroundColor)
                : theme.scaffoldBackgroundColor,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
        child: CodeField(
          controller: codeController,
          focusNode: focusNode,
          expands: false,
          wrap: true,
          enabled: enabled,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          background: pickBackgroundFromTheme
              ? (themeMap[editorThemeId]?['root']?.backgroundColor)
              : theme.scaffoldBackgroundColor,
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
            background: pickBackgroundFromTheme
                ? (themeMap[editorThemeId]?['root']?.backgroundColor)
                : theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
