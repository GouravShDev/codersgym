part of 'code_editor_bloc.dart';

sealed class CodeEditorEvent extends Equatable {
  const CodeEditorEvent();

  @override
  List<Object> get props => [];
}

class CodeEditorCodeLoadConfig extends CodeEditorEvent {
  final Question question;
  const CodeEditorCodeLoadConfig(this.question);

  @override
  List<Object> get props => [question];
}

class CodeEditorCodeUpdateEvent extends CodeEditorEvent {
  final String updatedCode;

  const CodeEditorCodeUpdateEvent({
    required this.updatedCode,
  });
  @override
  List<Object> get props => [updatedCode];
}

class CodeEditorRunCodeEvent extends CodeEditorEvent {
  final Question question;

  const CodeEditorRunCodeEvent({
    required this.question,
  });
  @override
  List<Object> get props => [question];
}

class CodeEditorSubmitCodeEvent extends CodeEditorEvent {
  final Question question;

  const CodeEditorSubmitCodeEvent({
    required this.question,
  });
  @override
  List<Object> get props => [question];
}

class CodeEditorRunCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorRunCodeResultUpdateEvent({
    required this.executionResult,
  });
  @override
  List<Object> get props => [executionResult];
}

class CodeEditorSubmitCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorSubmitCodeResultUpdateEvent({
    required this.executionResult,
  });
  @override
  List<Object> get props => [executionResult];
}

class CodeEditorLanguageUpdateEvent extends CodeEditorEvent {
  final ProgrammingLanguage language;
  final Question question;

  const CodeEditorLanguageUpdateEvent({
    required this.language,
    required this.question,
  });

  @override
  List<Object> get props => [language, question];
}

class CodeEditorResetCodeEvent extends CodeEditorEvent {}

class CodeEditorFormatCodeEvent extends CodeEditorEvent {}
