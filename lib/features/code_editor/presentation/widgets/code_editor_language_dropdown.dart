import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeEditorLanguageDropDown extends StatelessWidget {
  const CodeEditorLanguageDropDown({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final codeEditorBloc = context.read<CodeEditorBloc>();
    return BlocBuilder<CodeEditorBloc, CodeEditorState>(
      buildWhen: (previous, current) => current.language != previous.language,
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: DropdownButton<ProgrammingLanguage>(
            value: codeEditorBloc.state.language,
            items: ProgrammingLanguage.values
                .map((lang) => DropdownMenuItem(
                      value: lang,
                      child: Text(
                        lang.displayText,
                        // style: TextStyle(
                        //   fontSize: 12,
                        // ),
                      ),
                    ))
                .toList(),
            onChanged: (language) {
              if (language != null &&
                  language != codeEditorBloc.state.language) {
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
                          codeEditorBloc.add(
                            CodeEditorLanguageUpdateEvent(
                              language: language,
                              question: question,
                            ),
                          );
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
      },
    );
  }
}
