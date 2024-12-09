part of 'code_editor_bloc.dart';

sealed class CodeEditorEvent extends Equatable {
  const CodeEditorEvent();

  @override
  List<Object> get props => [];
}

class CodeEditorCodeUpdateEvent extends CodeEditorEvent {
  final String updatedCode;

  const CodeEditorCodeUpdateEvent({
    required this.updatedCode,
  });
}

class CodeEditorRunCodeEvent extends CodeEditorEvent {
  final Question question;

  const CodeEditorRunCodeEvent({
    required this.question,
  });
}
class CodeEditorSubmitCodeEvent extends CodeEditorEvent {
  final Question question;

  const CodeEditorSubmitCodeEvent({
    required this.question,
  });
}

class CodeEditorRunCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorRunCodeResultUpdateEvent({
    required this.executionResult,
  });
}
class CodeEditorSubmitCodeResultUpdateEvent extends CodeEditorEvent {
  final CodeExecutionState executionResult;

  const CodeEditorSubmitCodeResultUpdateEvent({
    required this.executionResult,
  });
}
