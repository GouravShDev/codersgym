import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';

abstract interface class CodeEditorRepository {
  Future<Result<String, Exception>> runCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  });

  Future<Result<int, Exception>> submitCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  });

  Future<Result<CodeExecutionResult, Exception>> checkExcecutionResult({
    required String executionId,
  });
}
