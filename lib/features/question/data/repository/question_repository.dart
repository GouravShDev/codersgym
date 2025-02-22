import 'package:codersgym/core/api/leetcode_requests.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/features/question/data/entity/contest_entity.dart';
import 'package:codersgym/features/question/data/entity/daily_question_entity.dart';
import 'package:codersgym/features/question/data/entity/official_solution_entity.dart';
import 'package:codersgym/features/question/data/entity/problem_question_entity.dart';
import 'package:codersgym/features/question/data/entity/question_entity.dart';
import 'package:codersgym/features/question/data/entity/similar_question_entity.dart';
import 'package:codersgym/features/question/data/entity/solution_entity.dart';
import 'package:codersgym/features/question/data/entity/upcoming_contest_entity.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/model/solution.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final LeetcodeApi leetcodeApi;

  QuestionRepositoryImpl(this.leetcodeApi);
  @override
  Future<Result<Question, Exception>> getTodayChallenge() async {
    try {
      final data = await leetcodeApi.getDailyQuestion();

      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final question = DailyQuestionEntity.fromJson(data);

      return Success(question.toQuestion());
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<Question, Exception>> getQuestionContent(
      String questiontitleSlug) async {
    try {
      final data = await leetcodeApi.getQuestionContent(questiontitleSlug);
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final question = QuestionNodeEntity.fromJson(data['question']);

      return Success(question.toQuestion());
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<(List<Question>, int totalQuestionCount), Exception>>
      getProblemQuestion(
    ProblemQuestionQueryInput query,
  ) async {
    try {
      final data = await leetcodeApi.getProblemsList(
        categorySlug: query.categorySlug,
        filters: query.filters?.toFitlers(),
        limit: query.limit,
        skip: query.skip,
      );
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final problemset = ProblemsetQuestionsEntity.fromJson(data);
      final questionsList = problemset.problemsetQuestionList?.questions
              ?.map(
                (e) => e.toQuestion(),
              )
              .toList() ??
          [];
      final totalQuestionCount = problemset.problemsetQuestionList?.total ?? 0;

      return Success((
        questionsList,
        totalQuestionCount,
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<Contest>, Exception>> getUpcomingContests() async {
    try {
      final data = await leetcodeApi.getUpcomingContest();
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final contests = UpcomingContestEntity.fromJson(data);
      final contestsList = contests.topTwoContests
          ?.map(
            (e) => e.toContest(),
          )
          .toList();
      if (contestsList?.isEmpty ?? true) {
        return Failure(Exception("No Upcoming Contest found"));
      }
      return Success(contestsList!);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<Question>, Exception>> getSimilarQuestions(
    String questionTitleSlug,
  ) async {
    try {
      final data = await leetcodeApi.getSimilarQuestions(questionTitleSlug);
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final similarQuestions = SimilarQuestionEntity.fromJson(data);
      final similarQuestionsList =
          similarQuestions.question?.similarQuestionList
              ?.map(
                (e) => e.toQuestion(),
              )
              .toList();

      return Success(similarQuestionsList ?? []);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<bool, Exception>> hasOfficialSolution(
    String questiontitleSlug,
  ) async {
    try {
      final response = await leetcodeApi.hasOfficialSolution(questiontitleSlug);
      if (response == null) {
        return Failure(Exception("No data found"));
      }
      final solutionIdEntity = OfficialSolutionEntity.fromJson(response);
      if (solutionIdEntity.question == null) {
        // Question do not contains official solution
        return const Success(false);
      }
      return Success(true);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<Solution?, Exception>> getOfficialSolution(
    String questiontitleSlug,
  ) async {
    try {
      final solutionData =
          await leetcodeApi.getOfficialSolution(questiontitleSlug);
      if (solutionData == null) {
        return Failure(Exception("Failed to get official solution"));
      }
      final solutionEntity = OfficialSolutionEntity.fromJson(solutionData);
      return Success(
        solutionEntity.question?.solution?.toSolution(),
      );
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<TopicTags>, Exception>> getQuestionTags(
    String questiontitleSlug,
  ) async {
    try {
      final data = await leetcodeApi.getQuestionTags(questiontitleSlug);
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final questionEntity = QuestionNodeEntity.fromJson(data['question']);
      final tagsList = questionEntity.topicTags
          ?.map(
            (e) => e.toTopicTags(),
          )
          .toList();

      return Success(tagsList ?? []);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<String>, Exception>> getQuestionHints(
    String questiontitleSlug,
  ) async {
    try {
      final data = await leetcodeApi.getQuestionHints(questiontitleSlug);
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final questionEntity = QuestionNodeEntity.fromJson(data['question']);
      final hintList = questionEntity.hints;

      return Success(hintList ?? []);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}

extension ProblemFilterExt on ProblemFilter {
  Filters toFitlers() {
    return Filters(
      difficulty: difficulty,
      listId: listId,
      orderBy: orderBy,
      searchKeywords: searchKeywords,
      sortOrder: sortOrder,
      tags: tags,
    );
  }
}
