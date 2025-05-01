import 'dart:ui';

import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/leetcode_login_dialog.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeSubmitButton extends StatelessWidget {
  const CodeSubmitButton({
    super.key,
    required this.question,
    this.onSubmit,
  });
  final Question question;
  final Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final allowCodeRun = authBloc.isUserAuthenticatedWithLeetcodeAccount;
    return BlocBuilder<CodeEditorBloc, CodeEditorState>(
      builder: (context, state) {
        final isRunning = state.codeSubmissionState == CodeExecutionPending();

        return Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: (isRunning),
              child: const CircularProgressIndicator(),
            ),
            Visibility(
              maintainAnimation: true,
              maintainState: true,
              maintainSize: true,
              visible: !isRunning,
              child: (allowCodeRun)
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).focusColor,
                        foregroundColor:
                            Theme.of(context).colorScheme.successColor,
                        iconColor: Theme.of(context).colorScheme.successColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: const Icon(Icons.upload_file_outlined),
                      onPressed: () {
                        if (context
                            .read<CodeEditorBloc>()
                            .state
                            .isExecutionPending) {
                          return;
                        }
                        onSubmit?.call();
                        context.read<CodeEditorBloc>().add(
                              CodeEditorSubmitCodeEvent(question: question),
                            );
                      },
                      label: const Text('Submit'),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
