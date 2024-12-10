import 'dart:convert';

import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';

class CodeExecutionResultEntity {
  final int? statusCode;
  final String? lang;
  final bool? runSuccess;
  final String? compileError;
  final String? fullCompileError;
  final String? statusRuntime;
  final int? memory;
  final List<String>? codeAnswer;
  final List<String>? codeOutput;
  final List<String>? stdOutputList;
  final int? elapsedTime;
  final int? taskFinishTime;
  final String? taskName;
  final String? expectedOutput;
  final int? expectedStatusCode;
  final String? expectedLang;
  final bool? expectedRunSuccess;
  final String? expectedStatusRuntime;
  final int? expectedMemory;
  final String? expectedDisplayRuntime;
  final List<String>? expectedCodeAnswer;
  final List<String>? expectedCodeOutput;
  final List<String>? expectedStdOutputList;
  final String? lastTestcase;
  final int? expectedElapsedTime;
  final int? expectedTaskFinishTime;
  final String? expectedTaskName;
  final bool? correctAnswer;
  final String? compareResult;
  final int? totalCorrect;
  final int? totalTestcases;
  final double? runtimePercentile;
  final String? statusMemory;
  final double? memoryPercentile;
  final String? prettyLang;
  final String? submissionId;
  final String? statusMsg;
  final String? state;

  CodeExecutionResultEntity({
    this.statusCode,
    this.lang,
    this.runSuccess,
    this.compileError,
    this.fullCompileError,
    this.statusRuntime,
    this.memory,
    this.codeAnswer,
    this.codeOutput,
    this.stdOutputList,
    this.elapsedTime,
    this.taskFinishTime,
    this.taskName,
    this.expectedStatusCode,
    this.expectedLang,
    this.expectedRunSuccess,
    this.expectedStatusRuntime,
    this.expectedMemory,
    this.expectedDisplayRuntime,
    this.expectedCodeAnswer,
    this.expectedCodeOutput,
    this.expectedStdOutputList,
    this.expectedElapsedTime,
    this.expectedTaskFinishTime,
    this.expectedOutput,
    this.expectedTaskName,
    this.correctAnswer,
    this.compareResult,
    this.totalCorrect,
    this.totalTestcases,
    this.runtimePercentile,
    this.statusMemory,
    this.memoryPercentile,
    this.prettyLang,
    this.submissionId,
    this.statusMsg,
    this.state,
    this.lastTestcase,
  });

  factory CodeExecutionResultEntity.fromJson(Map<String, dynamic> json) =>
      CodeExecutionResultEntity(
        statusCode: json["status_code"],
        lang: json["lang"],
        runSuccess: json["run_success"],
        compileError: json["compile_error"],
        fullCompileError: json["full_compile_error"],
        statusRuntime: json["status_runtime"],
        memory: json["memory"],
        codeAnswer: json["code_answer"] == null
            ? []
            : List<String>.from(json["code_answer"]!.map((x) => x)),
        codeOutput: json["code_output"] == null
            ? []
            : (json["code_output"] is String)
                ? [json["code_output"]]
                : List<String>.from(json["code_output"]!.map((x) => x)),
        stdOutputList: json["std_output_list"] == null
            ? []
            : (json["std_output_list"] is String)
                ? json["std_output_list"]
                : List<String>.from(json["std_output_list"]!.map((x) => x)),
        elapsedTime: json["elapsed_time"],
        taskFinishTime: json["task_finish_time"],
        taskName: json["task_name"],
        expectedOutput: json['expected_output'],
        expectedStatusCode: json["expected_status_code"],
        expectedLang: json["expected_lang"],
        expectedRunSuccess: json["expected_run_success"],
        expectedStatusRuntime: json["expected_status_runtime"],
        expectedMemory: json["expected_memory"],
        expectedDisplayRuntime: json["expected_display_runtime"],
        expectedCodeAnswer: json["expected_code_answer"] == null
            ? []
            : List<String>.from(json["expected_code_answer"]!.map((x) => x)),
        expectedCodeOutput: json["expected_code_output"] == null
            ? []
            : List<String>.from(json["expected_code_output"]!.map((x) => x)),
        expectedStdOutputList: json["expected_std_output_list"] == null
            ? []
            : List<String>.from(
                json["expected_std_output_list"]!.map((x) => x)),
        expectedElapsedTime: json["expected_elapsed_time"],
        expectedTaskFinishTime: json["expected_task_finish_time"],
        expectedTaskName: json["expected_task_name"],
        correctAnswer: json["correct_answer"],
        compareResult: json["compare_result"],
        totalCorrect: json["total_correct"],
        totalTestcases: json["total_testcases"],
        runtimePercentile: json["runtime_percentile"]?.toDouble(),
        statusMemory: json["status_memory"],
        memoryPercentile: json["memory_percentile"]?.toDouble(),
        prettyLang: json["pretty_lang"],
        submissionId: json["submission_id"],
        statusMsg: json["status_msg"],
        state: json["state"],
        lastTestcase: json['last_testcase'],
      );
}

extension _CodeExecutionStateExt on String {
  CodeExecutionResultState _determineCodeExecutionState() {
    if (this == 'PENDING') {
      return CodeExecutionResultState.pending;
    } else if (this == 'STARTED') {
      return CodeExecutionResultState.started;
    } else if (this == 'SUCCESS') {
      return CodeExecutionResultState.success;
    } else {
      return CodeExecutionResultState.failed;
    }
  }
}

extension CodeExecutionResultEntityExt on CodeExecutionResultEntity {
  CodeExecutionResult toCodeExecutionResult() {
    final codeExecutionState = state?._determineCodeExecutionState() ??
        CodeExecutionResultState.failed;

    return CodeExecutionResult(
      runTime: statusRuntime != 'N/A' ? statusRuntime : null,
      statusMessage: statusMsg,
      state: codeExecutionState,
      lastTestCasesInputs: lastTestcase?.split('\n'),
      lastExpectedOutput: expectedOutput,
      // Leetcode gives empty string in each of the list in the response
      codeAnswers: codeAnswer
        ?..removeWhere(
          (element) => element.isEmpty,
        ),
      codePrintOutputs: stdOutputList
        ?..removeWhere(
          (element) => element.isEmpty,
        ),
      expectedCodeAnswer: expectedCodeAnswer
        ?..removeWhere(
          (element) => element.isEmpty,
        ),
      complieError: compileError,
      fullCompileError: fullCompileError,
      totalCorrect: totalCorrect,
      totalTestcases: totalTestcases,
      memoryPercentile: memoryPercentile,
      runtimePercentile: runtimePercentile,
      statusMemory: statusMemory,
      lastCodeOutput:
          (codeOutput?.isNotEmpty ?? false) ? codeOutput?.first : null,
    );
  }
}
