part of 'code_editor_bloc.dart';

class CodeEditorState extends Equatable {
  final bool isStateInitialized;
  final String? code;
  final Question? question;
  final ProgrammingLanguage? language;
  final CodeExecutionState executionState;
  final CodeExecutionState codeSubmissionState;
  final List<TestCase>? testCases;
  final bool isCodeFormatting;
  final bool isCodeEditorFocused;

  const CodeEditorState({
    required this.isStateInitialized,
    this.code,
    this.question,
    this.language,
    required this.executionState,
    required this.codeSubmissionState,
    this.testCases,
    required this.isCodeFormatting,
    this.isCodeEditorFocused = false,
  });

  factory CodeEditorState.initial() {
    return CodeEditorState(
      isStateInitialized: false,
      executionState: CodeExcecutionInitial(),
      codeSubmissionState: CodeExcecutionInitial(),
      isCodeFormatting: false,
    );
  }

  CodeEditorState copyWith({
    bool? isStateInitialized,
    String? code,
    ProgrammingLanguage? language,
    CodeExecutionState? executionState,
    CodeExecutionState? codeSubmissionState,
    List<TestCase>? testCases,
    Question? question,
    bool? isCodeFormatting,
    bool? isCodeEditorFocused,
  }) {
    return CodeEditorState(
      isStateInitialized: isStateInitialized ?? this.isStateInitialized,
      code: code ?? this.code,
      language: language ?? this.language,
      executionState: executionState ?? this.executionState,
      testCases: testCases ?? this.testCases,
      codeSubmissionState: codeSubmissionState ?? this.codeSubmissionState,
      question: question ?? this.question,
      isCodeFormatting: isCodeFormatting ?? this.isCodeFormatting,
      isCodeEditorFocused: isCodeEditorFocused ?? this.isCodeEditorFocused,
    );
  }

  @override
  List<Object?> get props => [
        code,
        language,
        executionState,
        testCases,
        codeSubmissionState,
        isStateInitialized,
        isCodeFormatting,
        isCodeEditorFocused,
      ];

  @override
  String toString() {
    return 'CodeEditorState { code: $code, language: $language, executionState: $executionState, codeSubmissionState: $codeSubmissionState, testCases: $testCases , isStateInitialized $isStateInitialized}';
  }
}

sealed class CodeExecutionState extends Equatable {
  @override
  List<Object> get props => [];
}

class CodeExcecutionInitial extends CodeExecutionState {}

class CodeExecutionPending extends CodeExecutionState {}

class CodeExecutionSuccess extends CodeExecutionState {
  final CodeExecutionResult result;

  CodeExecutionSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class CodeExecutionError extends CodeExecutionState {
  final String message;

  CodeExecutionError(this.message);
}
