import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/question_description_bottomsheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/run_code_result_sheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/test_case_bottom_sheet.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

@RoutePage()
class CodeEditorPage extends HookWidget implements AutoRouteWrapper {
  final String initialCode;
  final ProgrammingLanguage language;
  final Question question;
  final CodeEditorBloc codeEditorBloc;

  const CodeEditorPage({
    super.key,
    required this.initialCode,
    required this.language,
    required this.question,
    required this.codeEditorBloc,
  });

  @override
  Widget build(BuildContext context) {
    // Use hooks for state management
    final selectedLanguage = useState(language);
    final testResults = useState<List<TestCaseResult>>([]);
    final isFullScreen = useState(false);

    // Create a code controller using useRef to persist across rebuilds
    final codeController = useState(CodeController(
      text: initialCode,
      language: language.mode,
      modifiers: const [
        IndentModifier(),
        CloseBlockModifier(),
        TabModifier(),
      ],
    )).value;
    useEffect(() {
      codeController.addListener(() {
        codeEditorBloc
            .add(CodeEditorCodeUpdateEvent(updatedCode: codeController.text));
      });
      return () => codeController.dispose();
    }, []);

    // Run code function
    final runCode = useCallback(() {
      testResults.value.clear();
      context.read<CodeEditorBloc>().add(
            CodeEditorRunCodeEvent(question: question),
          );
      // });
    }, []);

    // Check if the device is in mobile view
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Mobile-friendly bottom sheet for problem description
    void showProblemDescriptionBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            QuestionDescriptionBottomsheet(question: question),
      );
    }

    // Build the main scaffold
    return BlocListener<CodeEditorBloc, CodeEditorState>(
      listenWhen: (previous, current) =>
          previous.executionState != current.executionState,
      listener: (context, state) {
        final executionState = state.executionState;
        switch (executionState) {
          case CodeExcecutionInitial():
          case CodeExecutionPending():
            break;
          case CodeExecutionSuccess():
            _onCodeExecutionSuccess(
              context,
              result: executionState.result,
              testcases: state.testCases ?? [],
            );
          case CodeExecutionError():
          // TODO: Handle this case.
        }
      },
      child: Scaffold(
          bottomNavigationBar: // Action Buttons and Run Results
              Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Test Results
                TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return TestCaseBottomSheet(
                          testcases: question.exampleTestCases ?? [],
                        );
                      },
                    );
                  },
                  label: Text("Test Cases"),
                  icon: Icon(Icons.bug_report),
                ),
                BlocBuilder<CodeEditorBloc, CodeEditorState>(
                  builder: (context, state) {
                    final isRunning =
                        state.executionState == CodeExecutionPending();
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: (isRunning),
                          child: CircularProgressIndicator(),
                        ),
                        Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          maintainSize: true,
                          visible: !isRunning,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: runCode,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Run Code'),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          appBar: isFullScreen.value
              ? null
              : AppBar(
                  title: Text(
                    question.title ?? '',
                  ),
                  actions: [
                    // Language Dropdown
                    DropdownButton<ProgrammingLanguage>(
                      value: selectedLanguage.value,
                      items: ProgrammingLanguage.values
                          .map((lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(
                                  lang.displayText,
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (language) {
                        if (language != null) {
                          selectedLanguage.value = language;
                          codeController.language = language.mode;
                        }
                      },
                    ),
                  ],
                ),
          body: _buildMobileLayout(
            context,
            codeController,
            testResults,
            isFullScreen,
            runCode,
            showProblemDescriptionBottomSheet,
          )),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    CodeController codeController,
    ValueNotifier<List<TestCaseResult>> testResults,
    ValueNotifier<bool> isFullScreen,
    VoidCallback runCode,
    VoidCallback showProblemDescriptionBottomSheet,
  ) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          // Problem Description Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: showProblemDescriptionBottomSheet,
                  icon: Icon(Icons.description_outlined),
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
                ),
                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(Icons.undo_rounded),
                ),
                IconButton(
                  onPressed: () {
                    codeController.historyController.redo();
                  },
                  icon: Icon(Icons.redo_rounded),
                ),
                IconButton(
                  onPressed: () {
                    isFullScreen.value = !isFullScreen.value;
                  },
                  icon: !isFullScreen.value
                      ? Icon(Icons.fullscreen_outlined)
                      : Icon(Icons.fullscreen_exit_outlined),
                ),
                Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 4.0,
                    ),
                  ),
                  icon: Icon(Icons.upload_file_outlined),
                  onPressed: () {
                    // TODO: Implement submit logic
                  },
                  label: const Text('Submit'),
                ),
              ],
            ),
          ),

          // Code Editor
          Expanded(
            child: Stack(
              children: [
                CodeTheme(
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
                      expands: true,
                      background: theme.scaffoldBackgroundColor,
                      gutterStyle: GutterStyle(
                        width: 68,
                        background: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: SizedBox(
                //     height: 700,
                //     child: TestCaseManager(
                //       code: initialCode,
                //       language: 'cpp',
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          CodingKeys(
            codeController: codeController,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    CodeController codeController,
    ValueNotifier<List<TestCaseResult>> testResults,
    VoidCallback runCode,
  ) {
    return Row(
      children: [
        // Problem Description Panel
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Problem Description',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(question.content ?? ''),
                  const SizedBox(height: 16),
                  const Text(
                    'Test Cases',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...question.exampleTestCases?.map((testCase) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Input: ${testCase}'),
                          )) ??
                      [],
                ],
              ),
            ),
          ),
        ),

        // Code Editor Panel
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: CodeField(
                    controller: codeController,
                    expands: true,
                  ),
                ),
              ),

              // Action Buttons and Run Results
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: runCode,
                      child: const Text('Run Code'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement submit logic
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Placeholder method for test case checking
  bool _checkTestCase(TestCase testCase) {
    // Placeholder for actual test case checking logic
    // In a real implementation, this would involve running the code
    // with the test case input and comparing the output
    return true;
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider.value(
      value: codeEditorBloc,
      child: this,
    );
  }

  void _onCodeExecutionSuccess(
    BuildContext context, {
    required CodeExecutionResult result,
    required List<TestCase> testcases,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return RunCodeResultSheet(
          testcases: testcases,
          executionResult: result,
        );
      },
    );
  }
}

class TestCaseResult {
  final TestCase testCase;
  final bool isPassed;
  final String output;

  const TestCaseResult({
    required this.testCase,
    required this.isPassed,
    required this.output,
  });
}
