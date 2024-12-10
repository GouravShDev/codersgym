import 'package:bloc/bloc.dart';
import 'package:codersgym/core/utils/storage/local_storage_manager.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:collection/collection.dart';

part 'code_editor_event.dart';
part 'code_editor_state.dart';

class CodeEditorBloc extends Bloc<CodeEditorEvent, CodeEditorState> {
  final CodeEditorRepository _codeEdtiorRepository;
  final StorageManager _localStorageManager;

  static const _preferedCodingLanguageKey = 'preferedCodingLang';
  Timer? _timer;
  CodeEditorState previousState = CodeEditorState.initial();
  CodeEditorBloc(this._codeEdtiorRepository, this._localStorageManager)
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
        case CodeEditorCodeLoadConfig():
          _onCodeEditorCodeLoadConfig(event, emit);
          break;
        case CodeEditorLanguageUpdateEvent():
          _onCodeEditorLanguageUpdateEvent(event, emit);
          break;
        case CodeEditorFormatCodeEvent():
          await _onCodeEditorFormatCodeEvent(event, emit);
          break;
        case CodeEditorResetCodeEvent():
          _onCodeEditorResetCodeEvent(event, emit);
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  void onTransition(Transition<CodeEditorEvent, CodeEditorState> transition) {
    super.onTransition(transition);
    if (transition.currentState != previousState) {
      previousState = transition.currentState;
    }
  }

  Future<void> _onCodeEditorRunCodeEvent(
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

  Future<void> _onCodeEditorCodeLoadConfig(
    CodeEditorCodeLoadConfig event,
    Emitter<CodeEditorState> emit,
  ) async {
    final lastSelectedLanguage =
        await _localStorageManager.getString(_preferedCodingLanguageKey);

    final language = lastSelectedLanguage != null
        ? ProgrammingLanguage.values.byName(lastSelectedLanguage)
        : ProgrammingLanguage.cpp;
    final code = event.question.codeSnippets
        ?.firstWhereOrNull(
          (element) => element.langSlug == language.name,
        )
        ?.code;
    emit(
      state.copyWith(
        isStateInitialized: true,
        language: language,
        code: code ?? '',
        question: event.question,
      ),
    );
  }

  void _onCodeEditorLanguageUpdateEvent(
      CodeEditorLanguageUpdateEvent event, Emitter<CodeEditorState> emit) {
    _localStorageManager.putString(
      _preferedCodingLanguageKey,
      event.language.name,
    );
    final code = event.question.codeSnippets
        ?.firstWhereOrNull(
          (element) => element.langSlug == event.language.name,
        )
        ?.code;
    emit(
      state.copyWith(
        language: event.language,
        code: code,
      ),
    );
  }

  Future<void> _onCodeEditorFormatCodeEvent(
    CodeEditorFormatCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) async {
    emit(state.copyWith(
      isCodeFormatting: true,
    ));
    final codeFormatResult = await _codeEdtiorRepository.formatCode(
        code: state.code,
        tabSize: 4,
        programmingLanguageCode: state.language.formatUrlCode);

    codeFormatResult.when(
      onSuccess: (formattedCode) {
        emit(state.copyWith(
          code: formattedCode,
          isCodeFormatting: false,
        ));
      },
      onFailure: (exception) {},
    );
  }

  void _onCodeEditorResetCodeEvent(
    CodeEditorResetCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) {
    final code = state.question?.codeSnippets
        ?.firstWhereOrNull(
          (element) => element.langSlug == state.language.name,
        )
        ?.code;
    emit(
      state.copyWith(code: code),
    );
  }
}
