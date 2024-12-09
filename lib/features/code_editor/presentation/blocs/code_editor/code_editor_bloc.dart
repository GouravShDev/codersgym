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
        case CodeEditorSubmitCodeEvent():
          await _onCodeEditorSubmitCodeEvent(event, emit);
          break;
        case CodeEditorSubmitCodeResultUpdateEvent():
          _onCodeEditorSubmitCodeResultUpdateEvent(event, emit);
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
    final runCodeResult = await _codeEdtiorRepository.runCode(
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
    if (runCodeResult.isFailure) {
      emit(state.copyWith(executionState: CodeExecutionError()));
      return;
    }

    // Start polling for execution result
    _monitorCodeExecution(
      executionId: runCodeResult.getSuccessValue,
      onCodeExecutionResultRecieved: (executionResultState) {
        add(
          CodeEditorRunCodeResultUpdateEvent(
            executionResult: executionResultState,
          ),
        );
      },
    );
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

  Future<void> _onCodeEditorSubmitCodeEvent(
    CodeEditorSubmitCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        codeSubmissionState: CodeExecutionPending(),
        // Might need to modify when custom testcase feature is implemented
        testCases: event.question.exampleTestCases,
      ),
    );
    final runSubmitCodeResult = await _codeEdtiorRepository.submitCode(
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
    if (runSubmitCodeResult.isFailure) {
      emit(state.copyWith(executionState: CodeExecutionError()));
      return;
    }

    // Start polling for execution result
    _monitorCodeExecution(
      executionId: runSubmitCodeResult.getSuccessValue.toString(),
      onCodeExecutionResultRecieved: (executionResultState) {
        add(
          CodeEditorSubmitCodeResultUpdateEvent(
            executionResult: executionResultState,
          ),
        );
      },
    );
  }

  void _monitorCodeExecution({
    required String executionId,
    required Function(CodeExecutionState) onCodeExecutionResultRecieved,
  }) {
    int timeoutInSeconds = 5;
    int elapsedSeconds = 0;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (elapsedSeconds >= timeoutInSeconds) {
        onCodeExecutionResultRecieved(CodeExecutionError());

        _timer?.cancel();
        return;
      }
      elapsedSeconds++;

      final executionResult = await _codeEdtiorRepository.checkExcecutionResult(
        executionId: executionId,
      );
      if (executionResult.isFailure) {
        onCodeExecutionResultRecieved(
          CodeExecutionError(),
        );
        _timer?.cancel();
        return;
      }

      if (executionResult.getSuccessValue.state ==
          CodeExecutionResultState.success) {
        onCodeExecutionResultRecieved(
          CodeExecutionSuccess(
            executionResult.getSuccessValue,
          ),
        );
        _timer?.cancel();
      }
    });
  }

  void _onCodeEditorSubmitCodeResultUpdateEvent(
      CodeEditorSubmitCodeResultUpdateEvent event,
      Emitter<CodeEditorState> emit) {
    emit(
      state.copyWith(
        codeSubmissionState: event.executionResult,
      ),
    );
  }
}
