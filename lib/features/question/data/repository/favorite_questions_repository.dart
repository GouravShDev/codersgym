import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/api/leetcode_requests.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/core/services/firebase_remote_config_service.dart';
import 'package:codersgym/features/question/data/entity/favorite_list_entity.dart';
import 'package:codersgym/features/question/data/entity/favorite_questions_list_entity.dart';
import 'package:codersgym/features/question/data/entity/problem_list_progress_entity.dart';
import 'package:codersgym/features/question/data/entity/problem_sheet_entity.dart';
import 'package:codersgym/features/question/data/entity/question_entity.dart';
import 'package:codersgym/features/question/domain/model/favorite_problemset.dart';
import 'package:codersgym/features/question/domain/model/problem_list_progress.dart';
import 'package:codersgym/features/question/domain/model/problem_sheet.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';

class FavoriteQuestionsRepositoryImp implements FavoriteQuestionsRepository {
  final LeetcodeApi leetcodeApi;
  final FirebaseRemoteConfigService remoteConfigService;

  FavoriteQuestionsRepositoryImp(this.leetcodeApi, this.remoteConfigService);

  @override
  Future<Result<(List<Question>, int totalQuestionCount), Exception>>
      getFavoriteQuesitions(FavoriteQuestionQueryInput query) async {
    try {
      final data = await leetcodeApi.getFavoriteQuestionList(
        favoriteSlug: query.favoriteSlug,
        sortBy: query.sortOption?.toSortBy() ?? SortBy(),
        limit: query.limit,
        skip: query.skip,
        filtersV2: query.problemFilterV2,
      );
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final problemset = FavoriteQuestionsListEntity.fromJson(data);
      final questionsList = problemset.favoriteQuestionList?.questions
              ?.map(
                (e) => e.toQuestion(),
              )
              .toList() ??
          [];
      final totalQuestionCount = problemset.favoriteQuestionList?.total ?? 0;

      return Success((
        questionsList,
        totalQuestionCount,
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<
      Result<
          ({
            List<FavoriteProblemset> collectedProblemset,
            List<FavoriteProblemset> createdProblemset
          }),
          Exception>> getFavorites() async {
    try {
      final data = await leetcodeApi.getMyFavoritesList();
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final myCreatedFavoriteList =
          FavoriteListEntity.fromJson(data['myCreatedFavoriteList']).favorites;
      final myCollectedFavoriteList =
          FavoriteListEntity.fromJson(data['myCollectedFavoriteList'])
              .favorites;

      return Success((
        createdProblemset: myCreatedFavoriteList
            .map(
              (e) => e.toFavoriteProblemSet(),
            )
            .toList(),
        collectedProblemset: myCollectedFavoriteList
            .map(
              (e) => e.toFavoriteProblemSet(),
            )
            .toList(),
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<ProblemSheet>, Exception>> getProblemSheets() async {
    final sheets = remoteConfigService.getJson('problem_sheets');
    if (sheets == null) {
      return Failure(Exception("No data found"));
    }
    final problemSheets = ProblemSheetsEntity.fromJson(sheets);

    return Success(
      problemSheets.list.map((e) => e.toProblemSheet()).toList(),
    );
  }

  @override
  Future<Result<ProblemListProgress, Exception>> getProblemListProgess(
    String favoriteSlug,
  ) async {
    try {
      final data = await leetcodeApi.getProblemListProgress(
        favoriteSlug,
      );
      if (data == null) {
        return Failure(Exception("No data found"));
      }
      final problemListProgress = ProblemListProgressEntity.fromJson(data);

      return Success(
        problemListProgress.toProblemListProgress(),
      );
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
