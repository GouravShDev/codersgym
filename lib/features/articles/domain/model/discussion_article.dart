import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart';

class DiscussionArticle {
  final String? uuid;
  final String? title;
  final String? slug;
  final String? summary;
  final String? authorName;
  final String? content;
  final String? authorAvatar;
  final String? createdAt;
  final int? hitCount;
  final int? upvoteCount;
  final int? commentCount;
  final List<String>? tags;
  final int? topicId;

  DiscussionArticle({
    required this.uuid,
    required this.title,
    required this.slug,
    required this.content,
    required this.summary,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    required this.hitCount,
    required this.upvoteCount,
    required this.commentCount,
    required this.tags,
    required this.topicId,
  });

  factory DiscussionArticle.fromArticleNode(ArticleNode node) {
    return DiscussionArticle(
        uuid: node.uuid,
        title: node.title,
        content: node.content,
        slug: node.slug,
        summary: node.summary,
        authorName: node.author?.realName,
        authorAvatar: node.author?.userAvatar,
        createdAt: node.createdAt,
        hitCount: node.hitCount,
        topicId: node.topicId,
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

  DiscussionArticle copyWith({
    String? uuid,
    String? title,
    String? slug,
    String? summary,
    String? authorName,
    String? content,
    String? authorAvatar,
    String? createdAt,
    int? hitCount,
    int? upvoteCount,
    int? commentCount,
    List<String>? tags,
    int? topicId,
  }) =>
      DiscussionArticle(
        uuid: uuid ?? this.uuid,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        summary: summary ?? this.summary,
        authorName: authorName ?? this.authorName,
        content: content ?? this.content,
        authorAvatar: authorAvatar ?? this.authorAvatar,
        hitCount: hitCount ?? this.hitCount,
        upvoteCount: upvoteCount ?? this.upvoteCount,
        commentCount: commentCount ?? this.commentCount,
        createdAt: createdAt ?? this.createdAt,
        tags: tags ?? this.tags,
        topicId: topicId ?? this.topicId,
      );
}
