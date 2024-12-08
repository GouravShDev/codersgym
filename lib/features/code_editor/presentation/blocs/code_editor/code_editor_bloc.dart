import 'package:bloc/bloc.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

part 'code_editor_event.dart';
part 'code_editor_state.dart';

class CodeEditorBloc extends Bloc<CodeEditorEvent, CodeEditorState> {
  final CodeEditorRepository _codeEdtiorRepository;
  Timer? _timer;
  CodeEditorBloc(this._codeEdtiorRepository)
      : super(CodeEditorState.initial()) {
    on<CodeEditorEvent>((event, emit) async {
      switch (event) {
        case CodeEditorRunCodeEvent():
          await _onCodeEditorRunCodeEvent(event, emit);
          break;
        case CodeEditorRunCodeResultUpdateEvent():
          _onCodeEdtiorRunCodeResultUpdate(event, emit);
          break;
        case CodeEditorCodeUpdateEvent():
          _onCodeEditorCodeUpdateEvent(event, emit);
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  _onCodeEditorRunCodeEvent(
    CodeEditorRunCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        executionState: CodeExecutionPending(),
        // Might need to modify when custom testcase feature is implemented
        testCases: event.question.exampleTestCases,
      ),
    );
    final codeExceutionResult = await _codeEdtiorRepository.runCode(
      questionTitleSlug: event.question.titleSlug ?? "",
      questionId: event.question.questionId ?? '0',
      programmingLanguage: ProgrammingLanguage.cpp.name,
      code: state.code,
      testCases: event.question.exampleTestCases
              ?.map(
                (e) => e.inputs.join('\n'),
              )
              .join('\n') ??
          '',
    );
    if (codeExceutionResult.isFailure) {
      emit(state.copyWith(executionState: CodeExecutionError()));
      return;
    }

    // Start polling for execution result
    int timeoutInSeconds = 5;
    int elapsedSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (elapsedSeconds >= timeoutInSeconds) {
        add(CodeEditorRunCodeResultUpdateEvent(
          executionResult: CodeExecutionError(),
        ));
        _timer?.cancel();
        return;
      }
      elapsedSeconds++;

      final executionResult = await _codeEdtiorRepository.checkExcecutionResult(
          executionId: codeExceutionResult.getSuccessValue);
      if (executionResult.isFailure) {
        add(CodeEditorRunCodeResultUpdateEvent(
          executionResult: CodeExecutionError(),
        ));
        _timer?.cancel();
        return;
      }

      if (executionResult.getSuccessValue.state ==
          CodeExecutionResultState.success) {
        add(CodeEditorRunCodeResultUpdateEvent(
          executionResult: CodeExecutionSuccess(
            executionResult.getSuccessValue,
          ),
        ));
        _timer?.cancel();
      }
    });
  }

  void _onCodeEdtiorRunCodeResultUpdate(
    CodeEditorRunCodeResultUpdateEvent event,
    Emitter<CodeEditorState> emit,
  ) {
    emit(
      state.copyWith(
        executionState: event.executionResult,
      ),
    );
  }

  void _onCodeEditorCodeUpdateEvent(
      CodeEditorCodeUpdateEvent event, Emitter<CodeEditorState> emit) {
    emit(
      state.copyWith(
        code: event.updatedCode,
      ),
    );
  }
}
