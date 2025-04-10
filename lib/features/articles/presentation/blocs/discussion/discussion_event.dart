part of 'discussion_bloc.dart';

sealed class DiscussionEvent {
  const DiscussionEvent();
}

final class FetchDiscussionListEvent extends DiscussionEvent {
  final String? orderBy;
  final List<TopicTags>? categoryTags;
  final String? searchQuery;
  final int? skip;

  FetchDiscussionListEvent(
      {required this.orderBy,
      required this.categoryTags,
      required this.searchQuery,
      this.skip});
}
