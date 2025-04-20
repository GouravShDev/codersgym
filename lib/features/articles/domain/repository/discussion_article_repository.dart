import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/common/data/models/tag.dart';

abstract class DiscussionArticleRepository {
  Future<
      Result<({List<DiscussionArticle> articleList, int totalArticleCount}),
          Exception>> getDiscussionArticles(
    DiscussionArticlesInput input,
  );
  Future<Result<DiscussionArticle, Exception>> getDiscussionArticleDetail(
    int articleId,
  );
  Future<Result<List<Tag>, Exception>> getDiscussionTags();
}

class DiscussionArticlesInput {
  final String? orderBy;
  final List<String> keywords;
  final List<String>? tagSlugs;
  final int skip;
  final int first;

  DiscussionArticlesInput({
    required this.skip,
    required this.first,
    this.orderBy,
    this.keywords = const [""],
    this.tagSlugs,
  });
}
