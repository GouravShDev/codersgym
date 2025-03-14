import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';

enum ProblemSortOption {
  idAsc,
  idDesc,
  acceptanceRateAsc,
  acceptanceRateDesc,
  difficultyAsc,
  difficultyDesc;

  String get displayValue {
    switch (this) {
      case ProblemSortOption.idAsc:
        return 'ID ▲';
      case ProblemSortOption.idDesc:
        return 'ID ▼';
      case ProblemSortOption.acceptanceRateAsc:
        return 'AC ▲';
      case ProblemSortOption.acceptanceRateDesc:
        return 'AC ▼';
      case ProblemSortOption.difficultyAsc:
        return 'DF ▲';
      case ProblemSortOption.difficultyDesc:
        return 'DF ▼';
    }
  }

  String get orderBy {
    switch (this) {
      case ProblemSortOption.idAsc:
      case ProblemSortOption.idDesc:
        return "FRONTEND_ID";
      case ProblemSortOption.acceptanceRateAsc:
      case ProblemSortOption.acceptanceRateDesc:
        return "AC_RATE";
      case ProblemSortOption.difficultyAsc:
      case ProblemSortOption.difficultyDesc:
        return "DIFFICULTY";
    }
  }

  String get sortOrder {
    switch (this) {
      case ProblemSortOption.idAsc:
      case ProblemSortOption.acceptanceRateAsc:
      case ProblemSortOption.difficultyAsc:
        return "ASCENDING";
      case ProblemSortOption.idDesc:
      case ProblemSortOption.acceptanceRateDesc:
      case ProblemSortOption.difficultyDesc:
        return "DESCENDING";
    }
  }
}

extension ProblemSortOptionExt on ProblemSortOption {
  FavoriteQuestionSortOption toFavoriteSortOption() {
    return FavoriteQuestionSortOption(
      sortField: orderBy,
      sortOrder: sortOrder,
    );
  }
}
