import 'dart:math';

import 'package:codersgym/core/services/analytics.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/question_description_bottomsheet.dart';
import 'package:codersgym/features/common/data/models/analytics_events.dart';
import 'package:codersgym/features/common/widgets/app_snackbar.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class CodeEditorTopActionBar extends StatelessWidget {
  const CodeEditorTopActionBar({
    super.key,
    required this.onToggleFullScreen,
    required this.question,
    required this.isFullScreen,
    required this.codeController,
  });
  final VoidCallback onToggleFullScreen;
  final Question question;
  final bool isFullScreen;
  final CodeController codeController;

  void showProblemDescriptionBottomSheet(BuildContext context) {
    AnalyticsService().logCustomEvent(name: AnalyticsEvents.viewQuestionSheet);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionDescriptionBottomsheet(
        question: question,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final codeEditorBloc = context.read<CodeEditorBloc>();
    context.read<AuthBloc>();

    Widget iconButtonWithShadow({required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: child,
      );
    }

    final iconStyle = IconButton.styleFrom(
      backgroundColor: Colors.grey[850],
      padding: const EdgeInsets.all(
        8,
      ),
    );
    return Row(
      children: [
        iconButtonWithShadow(
          child: IconButton(
            onPressed: () => showProblemDescriptionBottomSheet(context),
            icon: const Icon(Icons.description_outlined),
            style: iconStyle,
          ),
        ),
        iconButtonWithShadow(
          child: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              AnalyticsService().logCustomEvent(name: AnalyticsEvents.copyCode);
              Clipboard.setData(
                ClipboardData(text: codeController.text),
              );
            },
            style: iconStyle,
          ),
        ),
        BlocBuilder<CodeEditorBloc, CodeEditorState>(
          buildWhen: (previous, current) =>
              previous.isCodeFormatting != current.isCodeFormatting ||
              previous.language != current.language,
          builder: (context, state) {
            if (formatUnSupportedLanguages.contains(state.language)) {
              return const SizedBox.shrink();
            }
            return iconButtonWithShadow(
              child: IconButton(
                onPressed: () {
                  final isAuthenticated = context
                      .read<AuthBloc>()
                      .isUserAuthenticatedWithLeetcodeAccount;
                  if (isAuthenticated) {
                    codeEditorBloc.add(
                      CodeEditorFormatCodeEvent(),
                    );
                  } else {
                    AnalyticsService().logError(
                      error:
                          "User tried to use code formatting feature with leetcode account",
                    );
                    AppSnackbar.showInfo(
                      context: context,
                      message:
                          "Please login via leetcode account to use this feature",
                      position: SnackbarPosition.bottom,
                    );
                  }
                },
                icon: state.isCodeFormatting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(),
                      )
                    : const Icon(Icons.format_align_left),
                style: iconStyle,
              ),
            );
          },
        ),
        iconButtonWithShadow(
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Warning'),
                    content: const Text(
                        'Are you sure you want to reset the code? This action cannot be undone.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Dismiss the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Reset the code and dismiss the dialog
                          codeEditorBloc.add(CodeEditorResetCodeEvent());
                          Navigator.of(context).pop();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Transform(
              transform: Matrix4.identity()..rotateY(pi), // Flips horizontally
              alignment: Alignment.center,
              child: const Icon(
                Icons.refresh_rounded,
              ),
            ),
            style: iconStyle,
          ),
        ),
        iconButtonWithShadow(
          child: IconButton(
            onPressed: onToggleFullScreen,
            icon: !isFullScreen
                ? const Icon(Icons.fullscreen_outlined)
                : const Icon(Icons.fullscreen_exit_outlined),
            style: iconStyle,
          ),
        ),
        // const Spacer(),
        // CodeSubmitButton(
        //   allowCodeRun: allowCodeRun,
        //   question: question,
        // ),
      ],
    );
  }
}
