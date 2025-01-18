import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class AppCodeEditorField extends StatelessWidget {
  const AppCodeEditorField({
    super.key,
    required this.codeController,
    this.enabled,
  });
  final CodeController codeController;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CodeTheme(
      data: CodeThemeData(styles: monokaiSublimeTheme),
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor: theme.scaffoldBackgroundColor,
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
          background: theme.scaffoldBackgroundColor,
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
            background: theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
