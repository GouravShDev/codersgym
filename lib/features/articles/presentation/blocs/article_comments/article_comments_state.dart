part of 'article_comments_bloc.dart';

const int commentsPerPage = 5;

class ArticleCommentsState extends Equatable {
  const ArticleCommentsState({
    required this.comments,
    required this.isLoading,
    required this.error,
    required this.totalComments,
    required this.pageNo,
  });
  final List<ArticleComment> comments;
  final bool isLoading;
  final Exception? error;
  final int totalComments;
  final int pageNo;
  factory ArticleCommentsState.initial() {
    return const ArticleCommentsState(
      comments: [],
      isLoading: false,
      error: null,
      totalComments: 0,
      pageNo: 0,
    );
  }

  ArticleCommentsState copyWith({
    List<ArticleComment>? comments,
    bool? isLoading,
    Exception? error,
    int? totalComments,
    int? pageNo,
  }) {
    return ArticleCommentsState(
        comments: comments ?? this.comments,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        totalComments: totalComments ?? this.totalComments,
        pageNo: pageNo ?? this.pageNo);
  }

  @override
  List<Object?> get props => [
        comments,
        isLoading,
        error,
        totalComments,
        pageNo,
      ];
}
