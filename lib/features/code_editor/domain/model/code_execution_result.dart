import 'package:equatable/equatable.dart';

class CodeExecutionResult extends Equatable {
  final String? runTime;
  final String? statusMessage;
  final CodeExecutionResultState state;
  final List<String>? codeAnswers;
  final List<String>? codePrintOutputs;
  final List<String>? expectedCodeAnswer;
  final int? totalCorrect;
  final int? totalTestcases;
  final String? complieError;
  final String? fullCompileError;

  final String? statusMemory;

  final double? runtimePercentile;

  final double? memoryPercentile;

  final List<String>? lastTestCasesInputs;
  final String? lastExpectedOutput;
  final String? lastCodeOutput;

  const CodeExecutionResult({
    required this.runTime,
    required this.statusMessage,
    this.state = CodeExecutionResultState.pending,
    this.codeAnswers,
    this.codePrintOutputs,
    this.expectedCodeAnswer,
    this.totalCorrect,
    this.totalTestcases,
    this.complieError,
    this.fullCompileError,
    this.statusMemory,
    this.runtimePercentile,
    this.memoryPercentile,
    this.lastTestCasesInputs,
    this.lastExpectedOutput,
    this.lastCodeOutput,
  });

  bool get didCodeResultInError =>
      statusMessage != 'Accepted' || (totalCorrect != totalTestcases);

  String get codeExecutionResultMessage {
    if (statusMessage != 'Accepted') {
      return statusMessage ?? 'Something Went Wrong';
    } else if (totalCorrect == totalTestcases) {
      return 'Accepted';
    } else {
      return 'Wrong Answer';
    }
  }

  @override
  List<Object?> get props => [
        runTime,
        statusMessage,
        state,
        codeAnswers,
        codePrintOutputs,
        expectedCodeAnswer,
        totalCorrect,
        totalTestcases,
        complieError,
        fullCompileError,
        statusMemory,
        runtimePercentile,
        memoryPercentile,
        lastTestCasesInputs,
        lastExpectedOutput,
        lastCodeOutput,
      ];
}

enum CodeExecutionResultState { pending, started, success, failed }
