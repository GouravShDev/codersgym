part of 'article_comments_bloc.dart';

sealed class ArticleCommentsEvent extends Equatable {
  const ArticleCommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchArticleCommentsEvent extends ArticleCommentsEvent {
  final int numPerPage;
  final String orderBy;
  final int pageNo;
  final int topicId;

  const FetchArticleCommentsEvent({
    this.numPerPage = commentsPerPage,
    this.orderBy = "best",
    required this.pageNo,
    required this.topicId,
  });
}
