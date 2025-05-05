import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/services/analytics.dart';
import 'package:codersgym/core/theme/app_code_editor_theme.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_configuration.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/code_editor/code_editor_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/coding_configuration/coding_configuration_cubit.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_language_dropdown.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_editor_top_action_bar.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_run_button.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_submit_button.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/code_successful_submission_dialog.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/run_code_result_sheet.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/test_case_bottom_sheet.dart';
import 'package:codersgym/features/common/data/models/analytics_events.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:in_app_review/in_app_review.dart';

@RoutePage()
class CodeEditorPage extends HookWidget implements AutoRouteWrapper {
  final Question question;

  const CodeEditorPage({
    super.key,
    required this.question,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<CodeEditorBloc>(
            param1: question.questionId,
          ),
        ),
        BlocProvider(
          create: (context) =>
              getIt.get<CodingConfigurationCubit>()..loadConfiguration(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<CodeEditorBloc>().add(CodeEditorCodeLoadConfig(question));
      return null;
    }, []);
    return BlocBuilder<CodeEditorBloc, CodeEditorState>(
      buildWhen: (previous, current) {
        return previous.isStateInitialized != current.isStateInitialized;
      },
      builder: (context, state) {
        if (!state.isStateInitialized) {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
        return CodeEditorPageBody(
          question: question,
        );
      },
    );
  }
}

class CodeEditorPageBody extends HookWidget {
  CodeEditorPageBody({
    super.key,
    required this.question,
  });

  final Question question;

  final modifiers = [
    const IndentModifier(),
    const TabModifier(),
  ];

  void _handleCodeAndLanguageChanges(
    ValueNotifier<CodeController> codeController,
    CodeEditorState prevState,
    CodeEditorState newState,
    CodingConfiguration? config,
  ) {
    if (prevState.language != newState.language) {
      codeController.value = CodeController(
        text: newState.code,
        language: (newState.language ?? ProgrammingLanguage.cpp).mode,
        modifiers: modifiers,
        params: (config != null)
            ? EditorParams(
                tabSpaces: config.tabSize,
              )
            : const EditorParams(),
      );
      return;
    }
    if (newState.code != codeController.value.fullText) {
      codeController.value.fullText = newState.code ?? '';
    }
  }

  void _handleExecutionStateChanges(
    BuildContext context,
    CodeEditorState prevState,
    CodeEditorState newState,
  ) {
    if (prevState.executionState != newState.executionState) {
      final executionState = newState.executionState;
      switch (executionState) {
        case CodeExecutionSuccess():
          _onCodeExecutionSuccess(
            context,
            result: executionState.result,
            testcases: newState.testCases ?? [],
          );
          break;
        case CodeExecutionError():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                executionState.message,
              ),
            ),
          );
          break;
        default:
          break; // Ignore other states
      }
    }
  }

  void _handleCodeSubmissionStateChanges(
    BuildContext context,
    CodeEditorState prevState,
    CodeEditorState newState,
  ) {
    if (prevState.codeSubmissionState != newState.codeSubmissionState) {
      final codeSubmissionState = newState.codeSubmissionState;
      switch (codeSubmissionState) {
        case CodeExecutionSuccess():
          final authBloc = context.read<AuthBloc>();
          final profileCubit = context.read<UserProfileCubit>();
          final authState = authBloc.state;
          if (authState is Authenticated) {
            profileCubit.getUserProfile(authState.userName);
          }
          _onCodeSubmissionExecutionSuccess(
            context,
            result: codeSubmissionState.result,
            testcases: newState.testCases ?? [],
          );
          break;
        case CodeExecutionError():
          // TODO: Handle this case.
          break;
        default:
          break; // Ignore other states
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use hooks for state management
    final isFullScreen = useState(false);
    final codeEditorBloc = context.read<CodeEditorBloc>();
    final focusNode = useFocusNode();
    final codingConfigurationCubit = context.read<CodingConfigurationCubit>();

    // Create a code controller using useRef to persist across rebuilds
    final codeControllerState = useState(
      CodeController(
        text: codeEditorBloc.state.code,
        language:
            (codeEditorBloc.state.language ?? ProgrammingLanguage.cpp).mode,
        modifiers: modifiers,
      ),
    );
    final codeController = codeControllerState.value;

    useEffect(() {
      codeController.addListener(() {
        // Prevent unnecessary emittion of state when code is already updated
        if (codeController.fullText == codeEditorBloc.state.code) return;
        codeEditorBloc.add(
          CodeEditorCodeUpdateEvent(
            updatedCode: codeController.fullText,
          ),
        );
      });
      focusNode.addListener(
        () {
          codeEditorBloc.add(
            CodeEditorFocusChangedEvent(focusNode.hasFocus),
          );
        },
      );
      final stateListner = codeEditorBloc.stream.listen(
        (newState) {
          final prevState = codeEditorBloc.previousState;
          final state = codingConfigurationCubit.state;
          final config = switch (state) {
            CodingConfigurationLoaded() => state.configuration,
            _ => null,
          };
          _handleCodeAndLanguageChanges(
            codeControllerState,
            prevState,
            newState,
            config,
          );
          if (!context.mounted) return;
          _handleExecutionStateChanges(context, prevState, newState);
          _handleCodeSubmissionStateChanges(context, prevState, newState);
        },
      );
      return () {
        stateListner.cancel();
        codeController.dispose();
      };
    }, [codeController]);

    // Run code function
    final onCodeRun = useCallback(() {
      if (context.read<CodeEditorBloc>().state.isExecutionPending) {
        return;
      }
      context.read<CodeEditorBloc>().add(
            CodeEditorRunCodeEvent(question: question),
          );
      // });
    }, []);

    // Build the main scaffold
    return BlocConsumer<CodingConfigurationCubit, CodingConfigurationState>(
      listener: (context, state) {
        final config = switch (state) {
          CodingConfigurationLoaded() => state.configuration,
          _ => null,
        };
        if (config == null) return;
        codeControllerState.value = CodeController(
          text: codeEditorBloc.state.code,
          language:
              (codeEditorBloc.state.language ?? ProgrammingLanguage.cpp).mode,
          modifiers: modifiers,
          params: EditorParams(
            tabSpaces: config.tabSize,
          ),
        );
      },
      builder: (context, state) {
        if (state is CodingConfigurationLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                question.title ?? '',
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final config = switch (state) {
          CodingConfigurationLoaded() => state.configuration,
          _ => null,
        };
        final currentThemeId =
            config?.themeId ?? AppCodeEditorTheme.defaultThemeId;
        return Scaffold(
          backgroundColor: !(config?.darkEditorBackground ?? true)
              ? (themeMap[currentThemeId]?['root']?.backgroundColor)
              : Theme.of(context).scaffoldBackgroundColor,
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
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).dividerColor,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return BlocProvider.value(
                          value: codeEditorBloc,
                          child: TestCaseBottomSheet(
                            testcases: codeEditorBloc.state.testCases ?? [],
                            onRunCode: onCodeRun,
                          ),
                        );
                      },
                    );
                  },
                  label: const Text("Test Cases"),
                  icon: const Icon(Icons.bug_report),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Row(
                    children: [
                      CodeRunButton(runCode: onCodeRun),
                      const SizedBox(
                        width: 4,
                      ),
                      CodeSubmitButton(question: question),
                    ],
                  ),
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
                    BlocBuilder<CodeEditorBloc, CodeEditorState>(
                      buildWhen: (previous, current) =>
                          current.language != previous.language,
                      builder: (context, state) {
                        return CodeEditorLanguageDropDown(
                          onLanguageChange: (language) {
                            codeEditorBloc.add(
                              CodeEditorLanguageUpdateEvent(
                                language: language,
                                question: question,
                              ),
                            );
                          },
                          currentLanguage:
                              state.language ?? ProgrammingLanguage.cpp,
                        );
                      },
                    ),
                  ],
                ),
          body: _buildEditorLayout(
            context,
            codeController,
            isFullScreen,
            onCodeRun,
            config,
            focusNode,
          ),
        );
      },
    );
  }

  Widget _buildEditorLayout(
    BuildContext context,
    CodeController codeController,
    ValueNotifier<bool> isFullScreen,
    VoidCallback runCode,
    CodingConfiguration? config,
    FocusNode focusNode,
  ) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CodeEditorTopActionBar(
              onToggleFullScreen: () {
                isFullScreen.value = !isFullScreen.value;
              },
              codeController: codeController,
              isFullScreen: isFullScreen.value,
              question: question,
            ),
          ),
          // Code Editor
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                    child: AppCodeEditorField(
                  codeController: codeController,
                  focusNode: focusNode,
                  keyboardType: (config?.hideKeyboard ?? false)
                      ? TextInputType.none
                      : null,
                  editorThemeId:
                      config?.themeId ?? AppCodeEditorTheme.defaultThemeId,
                  pickBackgroundFromTheme:
                      !(config?.darkEditorBackground ?? true),
                  fontSize: config?.fontSize.toDouble() ??
                      CodingConfiguration.defaultFontSize.toDouble(),
                )),
              ],
            ),
          ),
          BlocBuilder<CodingConfigurationCubit, CodingConfigurationState>(
            builder: (context, state) {
              final configuration = switch (state) {
                CodingConfigurationLoaded() => state.configuration.keysConfigs,
                CodingNoUserConfiguration() =>
                  CodingKeyConfig.defaultCodingKeyConfiguration,
                _ => <String>[],
              };
              if (state is CodingConfigurationLoaded &&
                  state.configuration.hideKeyboard) {
                return const SizedBox.shrink();
              }
              return BlocBuilder<CodeEditorBloc, CodeEditorState>(
                buildWhen: (previous, current) =>
                    previous.isCodeEditorFocused != current.isCodeEditorFocused,
                builder: (context, state) {
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticInOut,
                    child: Builder(builder: (context) {
                      if (!state.isCodeEditorFocused) {
                        return const SizedBox.shrink();
                      }
                      return CodingKeys(
                        codeController: codeController,
                        codingKeyIds: configuration,
                      );
                    }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _onCodeExecutionSuccess(
    BuildContext context, {
    required CodeExecutionResult result,
    required List<TestCase> testcases,
  }) {
    final codeEditorBloc = context.read<CodeEditorBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: codeEditorBloc,
          child: RunCodeResultSheet(
            sampleTestcases: testcases,
            executionResult: result,
            isCodeSubmitted: false,
          ),
        );
      },
    );
  }

  void _onCodeSubmissionExecutionSuccess(
    BuildContext context, {
    required CodeExecutionResult result,
    required List<TestCase> testcases,
  }) {
    final codeEditorBloc = context.read<CodeEditorBloc>();
    if (result.didCodeResultInError) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BlocProvider.value(
            value: codeEditorBloc,
            child: RunCodeResultSheet(
              sampleTestcases: testcases,
              executionResult: result,
              isCodeSubmitted: true,
            ),
          );
        },
      );
      return;
    }
    AnalyticsService().logCustomEvent(
      name: AnalyticsEvents.questionsCompleted,
      parameters: question.toAnalyticsMap(),
    );
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.isAvailable().then(
      (available) {
        if (available) {
          inAppReview.requestReview();
        }
      },
    );

    showDialog(
      context: context,
      builder: (context) => CodeSuccessfulSubmissionDialog(
        result: result,
      ),
    );
  }
}
