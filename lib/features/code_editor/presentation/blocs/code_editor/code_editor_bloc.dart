import 'package:codersgym/core/services/analytics.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/core/utils/track_analytic_mixin.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';
import 'package:codersgym/features/common/data/models/analytics_events.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'code_editor_event.dart';
part 'code_editor_state.dart';

class CodeEditorBloc extends HydratedBloc<CodeEditorEvent, CodeEditorState> {
  final CodeEditorRepository _codeEdtiorRepository;
  final StorageManager _localStorageManager;
  final String _questionId;

  final AnalyticsService _analyticsService = AnalyticsService();

  static const _preferedCodingLanguageKey = 'preferedCodingLang';
  Timer? _timer;
  CodeEditorState previousState = CodeEditorState.initial();
  CodeEditorBloc(
    this._codeEdtiorRepository,
    this._localStorageManager,
    this._questionId,
  ) : super(CodeEditorState.initial()) {
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
        case CodeEditorUpdateTestcaseEvent():
          _onCodeEditorUpdateTestcaseEvent(event, emit);
          break;
        case CodeEditorFocusChangedEvent():
          _onCodeEditorFocusChangedEvent(event, emit);
      }
    });
  }
  @override
  String get id => _questionId;

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
        testCases: state.testCases,
      ),
    );
    final runCodeResult = await _codeEdtiorRepository.runCode(
      questionTitleSlug: event.question.titleSlug ?? "",
      questionId: event.question.questionId ?? '0',
      programmingLanguage: (state.language ?? ProgrammingLanguage.cpp).name,
      code: state.code ?? '',
      testCases: state.testCases
              ?.map(
                (e) => e.inputs.join('\n'),
              )
              .join('\n') ??
          '',
    );
    if (isClosed) {
      return;
    }
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
    if (isClosed) return;
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
        testCases: state.testCases,
      ),
    );
    final runSubmitCodeResult = await _codeEdtiorRepository.submitCode(
      questionTitleSlug: event.question.titleSlug ?? "",
      questionId: event.question.questionId ?? '0',
      programmingLanguage: (state.language ?? ProgrammingLanguage.cpp).name,
      code: state.code ?? '',
      testCases: state.testCases
              ?.map(
                (e) => e.inputs.join('\n'),
              )
              .join('\n') ??
          '',
    );

    if (isClosed) return;
    if (runSubmitCodeResult.isFailure) {
      emit(
        state.copyWith(
          codeSubmissionState: CodeExecutionError(),
        ),
      );
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
        if (isClosed) return;
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
    if (isClosed) return;
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
    final defaultCode = event.question.codeSnippets
        ?.firstWhereOrNull(
          (element) => element.langSlug == language.name,
        )
        ?.code;
    // Get the cached values if its exists
    final currentCode = state.code;
    final currentProgrammingLanguage = state.language;

    if (isClosed) return;
    emit(
      state.copyWith(
        isStateInitialized: true,
        language: currentProgrammingLanguage ?? language,
        // Used the cached code if present
        code: currentCode ?? defaultCode,
        question: event.question,
        testCases: event.question.exampleTestCases,
      ),
    );
  }

  void _onCodeEditorLanguageUpdateEvent(
      CodeEditorLanguageUpdateEvent event, Emitter<CodeEditorState> emit) {
    _localStorageManager.putString(
      _preferedCodingLanguageKey,
      event.language.name,
    );
    _analyticsService.setUserProperties(
      name: AnalyticsEvents.programmingLanguage,
      value: event.language.displayText,
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
      code: state.code ?? '',
      tabSize: 4,
      programmingLanguageCode:
          (state.language ?? ProgrammingLanguage.cpp).formatUrlCode,
    );

    if (isClosed) return;
    codeFormatResult.when(
      onSuccess: (formattedCode) {
        emit(state.copyWith(
          code: formattedCode,
          isCodeFormatting: false,
        ));
      },
      onFailure: (exception) {
        emit(
          state.copyWith(
            isCodeFormatting: false,
          ),
        );
      },
    );
  }

  void _onCodeEditorResetCodeEvent(
    CodeEditorResetCodeEvent event,
    Emitter<CodeEditorState> emit,
  ) {
    final code = state.question?.codeSnippets
        ?.firstWhereOrNull(
          (element) =>
              element.langSlug ==
              (state.language ?? ProgrammingLanguage.cpp).name,
        )
        ?.code;
    emit(
      state.copyWith(code: code),
    );
  }

  void _onCodeEditorUpdateTestcaseEvent(
      CodeEditorUpdateTestcaseEvent event, Emitter<CodeEditorState> emit) {
    emit(
      state.copyWith(
        testCases: event.testcases,
      ),
    );
  }

  @override
  CodeEditorState? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return CodeEditorState.initial();
    return CodeEditorState.initial().copyWith(
      code: json['code'],
      language: ProgrammingLanguage.values.byName(json['language']),
    );
  }

  @override
  Map<String, dynamic>? toJson(CodeEditorState state) {
    return {
      "code": state.code,
      "language": state.language?.name,
    };
  }

  void _onCodeEditorFocusChangedEvent(
    CodeEditorFocusChangedEvent event,
    Emitter<CodeEditorState> emit,
  ) {
    emit(
      state.copyWith(
        isCodeEditorFocused: event.focus,
      ),
    );
  }
}
