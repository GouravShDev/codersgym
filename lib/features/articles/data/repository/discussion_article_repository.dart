import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/api/leetcode_requests.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/features/articles/data/entity/article_comment_entity.dart';
import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart'; // Assuming this exists
import 'package:codersgym/features/articles/domain/model/article_comment.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/domain/repository/discussion_article_repository.dart';
import 'package:codersgym/features/common/data/models/tag.dart'; // Assuming this exists

class DiscussionArticleRepositoryImp implements DiscussionArticleRepository {
  final LeetcodeApi leetcodeApi;

  DiscussionArticleRepositoryImp(this.leetcodeApi);

  @override
  Future<
      Result<({List<DiscussionArticle> articleList, int totalArticleCount}),
          Exception>> getDiscussionArticles(
      DiscussionArticlesInput input) async {
    try {
      final data = await leetcodeApi.getDiscussionArticles(
        orderBy: input.orderBy,
        keywords: input.keywords,
        tagSlugs: input.tagSlugs,
        skip: input.skip,
        first: input.first,
      );

      if (data == null) {
        return Failure(Exception("No data found"));
      }

      final discussionArticleList = DiscussionArticlesEntity.fromJson(
          data); // Assuming this entity exists
      final articles = discussionArticleList.articles
              ?.map((edge) => DiscussionArticle.fromArticleNode(edge))
              .toList() ??
          [];

      return Success((
        articleList: articles,
        totalArticleCount: discussionArticleList.totalNum ?? 0,
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<DiscussionArticle, Exception>> getDiscussionArticleDetail(
      int articleId) async {
    try {
      final data = await leetcodeApi.getDiscussionArticleDetail(
        articleId,
      );

      if (data == null) {
        return Failure(Exception("No data found"));
      }

      final discussionArticleDetail = ArticleNode.fromJson(
          data['ugcArticleDiscussionArticle']); // Assuming this entity exists
      return Success(
          DiscussionArticle.fromArticleNode(discussionArticleDetail));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<Result<List<Tag>, Exception>> getDiscussionTags() async {
    try {
      final data = await leetcodeApi
          .getDiscussionTags(); // Assuming this method exists in LeetcodeApi

      if (data == null) {
        return Failure(Exception("No data found"));
      }

      final discussionTags =
          (data['ugcArticleFollowedDiscussionTags'] as List?)?.map(
        (e) => DiscussionTagsEntity.fromJson(e),
      );

      final tags = discussionTags
              ?.map(
                (tag) => Tag(
                  id: tag.id?.toString(),
                  name: tag.name,
                  slug: tag.slug,
                ),
              )
              .toList() ??
          [];

      return Success(tags);
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }

  @override
  Future<
      Result<({List<ArticleComment> comments, int totalComments}),
          Exception>> getArticleComments(
    ArticleCommentInput input,
  ) async {
    try {
      final response = await leetcodeApi.getArticleComments(
        numPerPage: input.numPerPage,
        orderBy: input.orderBy,
        pageNo: input.pageNo,
        topicId: input.topicId,
      );

      if (response == null || response['topicComments']['data'] == null) {
        return Failure(Exception("No comments found"));
      }

      final List<dynamic> commentsData = response['topicComments']['data'];
      final List<ArticleCommentEntity> commentEntities = commentsData
          .map((json) => ArticleCommentEntity.fromJson(json))
          .toList();

      final List<ArticleComment> articleComments = commentEntities
          .map((entity) => ArticleComment.fromArticleCommentEntity(entity))
          .toList();

      return Success((
        comments: articleComments,
        totalComments: response['topicComments']['totalNum'] ?? 0,
      ));
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
