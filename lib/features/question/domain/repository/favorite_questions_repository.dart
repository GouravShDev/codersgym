import 'package:codersgym/core/api/leetcode_requests.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/question/domain/model/favorite_problemset.dart';
import 'package:codersgym/features/question/domain/model/problem_filter_v2.dart';
import 'package:codersgym/features/question/domain/model/problem_list_progress.dart';
import 'package:codersgym/features/question/domain/model/problem_sheet.dart';
import 'package:codersgym/features/question/domain/model/question.dart';

abstract interface class FavoriteQuestionsRepository {
  Future<Result<(List<Question>, int totalQuestionCount), Exception>>
      getFavoriteQuesitions(
    FavoriteQuestionQueryInput input,
  );

  Future<
      Result<
          ({
            List<FavoriteProblemset> createdProblemset,
            List<FavoriteProblemset> collectedProblemset
          }),
          Exception>> getFavorites();

  Future<Result<List<ProblemSheet>, Exception>> getProblemSheets();

  Future<Result<ProblemListProgress, Exception>> getProblemListProgess(
      String favoriteSlug);
}

class FavoriteQuestionQueryInput {
  final String? favoriteSlug;
  final int? limit;
  final FavoriteQuestionSortOption? sortOption;
  final ProblemFilterV2? problemFilterV2;
  final int? skip;

  FavoriteQuestionQueryInput({
    this.favoriteSlug,
    this.limit,
    this.sortOption,
    this.problemFilterV2,
    this.skip,
  });
}

class FavoriteQuestionSortOption {
  final String sortField;
  final String sortOrder;

  FavoriteQuestionSortOption({
    required this.sortField,
    required this.sortOrder,
  });

  SortBy toSortBy() {
    return SortBy(sortField: sortField, sortOrder: sortOrder);
  }
}
