import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart';

class DiscussionArticle {
  final String? uuid;
  final String? title;
  final String? slug;
  final String? summary;
  final String? authorName;
  final String? authorAvatar;
  final String? createdAt;
  final int? hitCount;
  final int? upvoteCount;
  final int? commentCount;
  final List<String>? tags;

  DiscussionArticle(
      {required this.uuid,
      required this.title,
      required this.slug,
      required this.summary,
      required this.authorName,
      required this.authorAvatar,
      required this.createdAt,
      required this.hitCount,
      required this.upvoteCount,
      required this.commentCount,
      required this.tags});

  factory DiscussionArticle.fromArticleNode(ArticleNode node) {
    return DiscussionArticle(
        uuid: node.uuid,
        title: node.title,
        slug: node.slug,
        summary: node.summary,
        authorName: node.author?.realName,
        authorAvatar: node.author?.userAvatar,
        createdAt: node.createdAt,
        hitCount: node.hitCount,
        upvoteCount: node.reactions
                ?.firstWhere(
                  (reaction) => reaction.reactionType == "UPVOTE",
                  orElse: () => Reaction(count: 0, reactionType: ""),
                )
                .count ??
            0,
        commentCount: node.topic?.topLevelCommentCount,
        tags: node.tags
            ?.map((tag) => tag.name ?? "")
            .where((name) => name.isNotEmpty)
            .toList());
  }
}
