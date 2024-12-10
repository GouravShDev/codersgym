import 'dart:math';
import 'dart:ui';

import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/leetcode_login_dialog.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/question_description_bottomsheet.dart';
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
    final authBloc = context.read<AuthBloc>();
    final allowCodeRun = authBloc.isUserAuthenticatedWithLeetcodeAccount;

    final iconStyle = IconButton.styleFrom(
      backgroundColor: Colors.grey[850],
      padding: const EdgeInsets.all(
        8,
      ),
    );
    return Row(
      children: [
        IconButton(
          onPressed: () => showProblemDescriptionBottomSheet(context),
          icon: const Icon(Icons.description_outlined),
          style: iconStyle,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: codeController.text),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Code copied to clipboard')),
            );
          },
          style: iconStyle,
        ),
        BlocBuilder<CodeEditorBloc, CodeEditorState>(
          buildWhen: (previous, current) =>
              previous.isCodeFormatting != current.isCodeFormatting,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                codeEditorBloc.add(
                  CodeEditorFormatCodeEvent(),
                );
              },
              icon: state.isCodeFormatting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.format_align_left),
              style: iconStyle,
            );
          },
        ),
        IconButton(
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
        IconButton(
          onPressed: onToggleFullScreen,
          icon: !isFullScreen
              ? const Icon(Icons.fullscreen_outlined)
              : const Icon(Icons.fullscreen_exit_outlined),
          style: iconStyle,
        ),
        const Spacer(),
        BlocBuilder<CodeEditorBloc, CodeEditorState>(
          builder: (context, state) {
            final isRunning =
                state.codeSubmissionState == CodeExecutionPending();

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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18.0,
                                vertical: 4.0,
                              ),
                            ),
                            icon: const Icon(Icons.upload_file_outlined),
                            onPressed: () {
                              codeEditorBloc.add(
                                CodeEditorSubmitCodeEvent(question: question),
                              );
                            },
                            label: const Text('Submit'),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // Match button shape
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX: 10.0, sigmaY: 10.0), // Blur intensity
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0,
                                    vertical: 4.0,
                                  ),
                                  backgroundColor: Colors.white
                                      .withOpacity(0.3), // Semi-transparent
                                ),
                                icon: const Icon(Icons
                                    .lock), // Replace icon for disabled state
                                onPressed: () =>
                                    LeetcodeLoginDialog.show(context),
                                label: const Text('Locked'),
                              ),
                            ),
                          )),
              ],
            );
          },
        ),
      ],
    );
  }
}
