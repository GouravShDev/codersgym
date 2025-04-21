import 'package:codersgym/features/articles/data/entity/article_comment_entity.dart';
import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart';

class ArticleComment {
  final String? id;
  final int? replyCount;
  final String? postId;
  final int? voteCount;
  final int? voteUpCount;
  final int? voteStatus;
  final String? content;
  final String? updationDate;
  final String? creationDate;
  final String? status;
  final bool? isHidden;
  final bool? anonymous;
  final Author? author;
  final bool? authorIsModerator;
  final bool? isOwnPost;

  ArticleComment({
    required this.id,
    required this.replyCount,
    required this.postId,
    required this.voteCount,
    required this.voteUpCount,
    required this.voteStatus,
    required this.content,
    required this.updationDate,
    required this.creationDate,
    required this.status,
    required this.isHidden,
    required this.anonymous,
    required this.author,
    required this.authorIsModerator,
    required this.isOwnPost,
  });

  factory ArticleComment.fromArticleCommentEntity(
      ArticleCommentEntity article) {
    return ArticleComment(
      id: article.id,
      replyCount: article.numChildren,
      postId: article.post?.id,
      voteCount: article.post?.voteCount,
      voteUpCount: article.post?.voteUpCount,
      voteStatus: article.post?.voteStatus,
      content: article.post?.content,
      updationDate: article.post?.updationDate,
      creationDate: article.post?.creationDate,
      status: article.post?.status,
      isHidden: article.post?.isHidden,
      anonymous: article.post?.anonymous,
      author: article.post?.author != null ? Author.fromAuthorEntity(article.post!.author!) : null,
      authorIsModerator: article.post?.authorIsModerator,
      isOwnPost: article.post?.isOwnPost,
    );
  }

  
  ArticleComment copyWith({
    String? id,
    int? replyCount,
    String? postId,
    int? voteCount,
    int? voteUpCount,
    int? voteStatus,
    String? content,
    String? updationDate,
    String? creationDate,
    String? status,
    bool? isHidden,
    bool? anonymous,
    Author? author,
    bool? authorIsModerator,
    bool? isOwnPost,
  }) {
    return ArticleComment(
      id: id ?? this.id,
      replyCount: replyCount ?? this.replyCount,
      postId: postId ?? this.postId,
      voteCount: voteCount ?? this.voteCount,
      voteUpCount: voteUpCount ?? this.voteUpCount,
      voteStatus: voteStatus ?? this.voteStatus,
      content: content ?? this.content,
      updationDate: updationDate ?? this.updationDate,
      creationDate: creationDate ?? this.creationDate,
      status: status ?? this.status,
      isHidden: isHidden ?? this.isHidden,
      anonymous: anonymous ?? this.anonymous,
      author: author ?? this.author,
      authorIsModerator: authorIsModerator ?? this.authorIsModerator,
      isOwnPost: isOwnPost ?? this.isOwnPost,
    );
  }
}
