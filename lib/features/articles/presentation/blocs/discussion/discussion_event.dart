part of 'discussion_bloc.dart';

sealed class DiscussionEvent {
  const DiscussionEvent();
}

final class FetchDiscussionArticlesEvent extends DiscussionEvent {
  final String? orderBy;
  final List<String>? keywords;
  final List<String>? tagSlugs;
  final int skip;
  final int first;

  FetchDiscussionArticlesEvent({
    this.orderBy = 'MOST_RELEVANT',
    this.keywords = const [],
    this.tagSlugs = const [],
    this.first = 10,
    this.skip = 0,
  });

  @override
  String toString() {
    return 'FetchDiscussionArticlesEvent('
        'skip: $skip, first: $first, orderBy: $orderBy, keywords: $keywords, tagSlugs: $tagSlugs)';
  }
}
