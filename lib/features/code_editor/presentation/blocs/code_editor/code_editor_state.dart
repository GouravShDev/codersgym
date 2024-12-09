part of 'code_editor_bloc.dart';

class CodeEditorState extends Equatable {
  final String code;
  final ProgrammingLanguage language;
  final CodeExecutionState executionState;
  final CodeExecutionState codeSubmissionState;
  final List<TestCase>? testCases;

  const CodeEditorState({
    required this.code,
    required this.language,
    required this.executionState,
    required this.codeSubmissionState,
    this.testCases,
  });

  factory CodeEditorState.initial() {
    return CodeEditorState(
      code: '',
      language: ProgrammingLanguage.cpp,
      executionState: CodeExcecutionInitial(),
      codeSubmissionState: CodeExcecutionInitial(),
    );
  }

  CodeEditorState copyWith({
    String? code,
    ProgrammingLanguage? language,
    CodeExecutionState? executionState,
    CodeExecutionState? codeSubmissionState,
    List<TestCase>? testCases,
  }) {
    return CodeEditorState(
      code: code ?? this.code,
      language: language ?? this.language,
      executionState: executionState ?? this.executionState,
      testCases: testCases ?? this.testCases,
      codeSubmissionState: codeSubmissionState ?? this.codeSubmissionState,
    );
  }

  @override
  List<Object?> get props =>
      [code, language, executionState, testCases, codeSubmissionState];
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

class CodeExecutionError extends CodeExecutionState {}
