import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/model/solution.dart';

abstract interface class QuestionRepository {
  Future<Result<Question, Exception>> getTodayChallenge();
  Future<Result<Question, Exception>> getQuestionContent(
    String questiontitleSlug,
  );
  Future<Result<(List<Question>, int totalQuestionCount), Exception>>
      getProblemQuestion(
    ProblemQuestionQueryInput query,
  );
  Future<Result<List<Contest>, Exception>> getUpcomingContests();
  Future<Result<List<Question>, Exception>> getSimilarQuestions(
      String questionId);
  Future<Result<Solution?, Exception>> getOfficialSolution(
    String questiontitleSlug,
  );
  Future<Result<bool, Exception>> hasOfficialSolution(
    String questiontitleSlug,
  );
  Future<Result<List<TopicTags>, Exception>> getQuestionTags(
    String questiontitleSlug,
  );
  Future<Result<List<String>, Exception>> getQuestionHints(
    String questiontitleSlug,
  );
}

class ProblemQuestionQueryInput {
  final String? categorySlug;
  final int? limit;
  final ProblemFilter? filters;
  final int? skip;

  ProblemQuestionQueryInput({
    this.categorySlug,
    this.limit,
    this.filters,
    this.skip,
  });
}

class ProblemFilter {
  final List<String?>? tags;
  final String? orderBy;
  final String? searchKeywords;
  final String? listId;
  final String? difficulty;
  final String? sortOrder;

  ProblemFilter({
    this.tags,
    this.orderBy,
    this.searchKeywords,
    this.listId,
    this.difficulty,
    this.sortOrder,
  });
}
