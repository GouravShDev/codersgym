import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeEditorLanguageDropDown extends StatelessWidget {
  const CodeEditorLanguageDropDown({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChange,
    this.showWarning = true,
  });
  final ProgrammingLanguage currentLanguage;
  final Function(ProgrammingLanguage language) onLanguageChange;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButton<ProgrammingLanguage>(
        value: currentLanguage,
        underline: const SizedBox.shrink(),
        items: ProgrammingLanguage.values
            .map((lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(
                    lang.displayText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    // style: TextStyle(
                    //   fontSize: 12,
                    // ),
                  ),
                ))
            .toList(),
        onChanged: (language) {
          if (language != null && language != currentLanguage) {
            if (!showWarning) {
              onLanguageChange(language);
              return;
            }
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Warning'),
                content: const Text(
                    'Changing the language will override the current code. Do you want to continue?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLanguageChange(language);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
