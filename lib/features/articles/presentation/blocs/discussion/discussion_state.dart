part of 'discussion_bloc.dart';

class DiscussionState extends Equatable {
  final List<DiscussionArticle> articles;
  final bool isLoading;
  final Exception? error;
  final bool moreArticlesAvailable;

  const DiscussionState({
    required this.articles,
    required this.isLoading,
    this.error,
    required this.moreArticlesAvailable,
  });

  factory DiscussionState.initial() => const DiscussionState(
        articles: [],
        isLoading: false,
        error: null,
        moreArticlesAvailable: true,
      );

  DiscussionState copyWith({
    List<DiscussionArticle>? articles,
    bool? isLoading,
    Exception? error,
    bool? moreArticlesAvailable,
  }) =>
      DiscussionState(
        articles: articles ?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        error: error, // Override error because we don't want to show error with new state
        moreArticlesAvailable:
            moreArticlesAvailable ?? this.moreArticlesAvailable,
      );

  @override
  List<Object?> get props =>
      [articles, isLoading, error, moreArticlesAvailable];
}
