import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/code_editor/data/entity/code_execution_result_entity.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:codersgym/features/code_editor/domain/repository/code_editor_repository.dart';

class CodeEditorRepositoryImp implements CodeEditorRepository {
  final LeetcodeApi leetcodeApi;

  CodeEditorRepositoryImp({required this.leetcodeApi});
  @override
  Future<Result<String, Exception>> runCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  }) async {
    try {
      final data = await leetcodeApi.runCode(
        questionTitleSlug: questionTitleSlug,
        questionId: questionId,
        programmingLanguage: programmingLanguage,
        code: code,
        testCases: testCases,
        submitCode: false,
      );
      final interpretId = data?['interpret_id'] as String?;
      if (data == null || interpretId == null) {
        return Failure(Exception("No data found"));
      }
      return Success(interpretId);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<CodeExecutionResult, Exception>> checkExcecutionResult(
      {required String executionId}) async {
    try {
      final data = await leetcodeApi.checkSubmission(
        submissionId: executionId,
      );
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final result = CodeExecutionResultEntity.fromJson(data);
      return Success(result.toCodeExecutionResult());
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<int, Exception>> submitCode({
    required String questionTitleSlug,
    required String questionId,
    required String programmingLanguage,
    required String code,
    required String testCases,
  }) async {
    try {
      final data = await leetcodeApi.runCode(
        questionTitleSlug: questionTitleSlug,
        questionId: questionId,
        programmingLanguage: programmingLanguage,
        code: code,
        testCases: testCases,
        submitCode: true,
      );
      final submissionId = data?['submission_id'] as int?;
      if (data == null || submissionId == null) {
        return Failure(Exception("No data found"));
      }
      return Success(submissionId);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
