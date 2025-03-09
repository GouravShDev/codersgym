part of 'favorite_quesions_list_bloc.dart';

sealed class FavoriteQuesionsListEvent{
  const FavoriteQuesionsListEvent();

}


class FetchFavoriteQuestionsListEvent extends FavoriteQuesionsListEvent {
  /// Pass skip : 0 for reseting the list to start from the begining
  /// otherwise it add the search result in the current list only
  final int? skip;
  final int? limit;
  final String favoriteSlug;
  final String? searchKeyword;
  final String? difficulty;
  final Set<TopicTags>? topics;
  final FavoriteQuestionSortOption? sortOption;

  const FetchFavoriteQuestionsListEvent({
    this.limit,
    this.skip,
    required this.favoriteSlug,
    this.searchKeyword,
    this.difficulty,
    this.topics,
    this.sortOption,
  });
}