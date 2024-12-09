import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/test_case_manager.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';

class RunCodeResultSheet extends StatelessWidget {
  const RunCodeResultSheet({
    super.key,
    required this.sampleTestcases,
    required this.executionResult,
    required this.isCodeSubmitted,
  });
  final List<TestCase> sampleTestcases;
  final CodeExecutionResult executionResult;
  final bool isCodeSubmitted;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          // Moves input sheet up when keyboard is opened
          padding: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: ListView(
              controller: scrollController,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                  ),
                  child: CodeExecutionResultHeading(
                      executionResult: executionResult),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                if (executionResult.fullCompileError != null)
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      executionResult.fullCompileError!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  )
                else
                  TestCaseManager(
                    testcases: isCodeSubmitted
                        ? [
                            TestCase(
                              inputs: executionResult.lastTestCasesInputs ?? [],
                            )
                          ]
                        : sampleTestcases,
                    readonly: true,
                    codeOutput: isCodeSubmitted
                        ? [executionResult.lastCodeOutput ?? '']
                        : executionResult.codeAnswers,
                    expectedOutput: isCodeSubmitted
                        ? [(executionResult.lastExpectedOutput ?? '')]
                        : executionResult.expectedCodeAnswer,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CodeExecutionResultHeading extends StatelessWidget {
  const CodeExecutionResultHeading({
    super.key,
    required this.executionResult,
  });

  final CodeExecutionResult executionResult;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          executionResult.codeExecutionResultMessage,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: executionResult.didCodeResultInError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.successColor,
              ),
        ),
        const SizedBox(
          width: 4,
        ),
        const SizedBox(
          height: 12,
          child: VerticalDivider(),
        ),
        const SizedBox(
          width: 4,
        ),
        if (executionResult.totalCorrect == executionResult.totalTestcases)
          Text(
            executionResult.runTime ?? '',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
        else
          Text(
            '${executionResult.totalCorrect}/${executionResult.totalTestcases} testcase passed',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
          ),
      ],
    );
  }
}
