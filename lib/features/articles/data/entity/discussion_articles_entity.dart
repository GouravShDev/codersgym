import 'package:codersgym/features/question/data/entity/community_post_entity.dart';

class DiscussionArticlesEntity {
  final int? totalNum;
  final bool? hasNextPage;
  final List<ArticleNode>? articles;

  DiscussionArticlesEntity({
    this.totalNum,
    this.hasNextPage,
    this.articles,
  });

  factory DiscussionArticlesEntity.fromJson(Map<String, dynamic> json) {
    return DiscussionArticlesEntity(
      totalNum: json['ugcArticleDiscussionArticles']['totalNum'],
      hasNextPage: json['ugcArticleDiscussionArticles']['pageInfo']
          ['hasNextPage'],
      articles: (json['ugcArticleDiscussionArticles']['edges'] as List?)
          ?.map((e) => ArticleNode.fromJson(e['node']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ugcArticleDiscussionArticles': {
        'totalNum': totalNum,
        'pageInfo': {'hasNextPage': hasNextPage},
        'edges': articles?.map((e) => {'node': e.toJson()}).toList(),
      },
    };
  }
}

class ActiveBadge {
  final String? icon;
  final String? displayName;

  ActiveBadge({this.icon, this.displayName});

  factory ActiveBadge.fromJson(Map<String, dynamic> json) =>
      ActiveBadge(icon: json['icon'], displayName: json['displayName']);
  Map<String, dynamic> toJson() => {'icon': icon, 'displayName': displayName};
}

class ArticleNode {
  final String? uuid;
  final String? title;
  final String? slug;
  final String? summary;
  final Author? author;
  final bool? isAnonymous;
  final bool? isOwner;
  final String? content;
  final bool? isSerialized;
  final dynamic scoreInfo;
  final String? articleType;
  final String? thumbnail;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final bool? isLeetcode;
  final bool? canSee;
  final bool? canEdit;
  final bool? isMyFavorite;
  final dynamic myReactionType;
  final int? topicId;
  final int? hitCount;
  final List<Reaction>? reactions;
  final List<DiscussionTagsEntity>? tags;
  final Topic? topic;

  ArticleNode({
    this.uuid,
    this.title,
    this.slug,
    this.summary,
    required this.author,
    this.content,
    this.isAnonymous,
    this.isOwner,
    this.isSerialized,
    this.scoreInfo,
    this.articleType,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
    this.status,
    required this.hitCount,
    required this.reactions,
    this.tags,
    required this.topic,
    this.isLeetcode,
    this.canSee,
    this.canEdit,
    this.isMyFavorite,
    this.myReactionType,
    this.topicId,
  });

  factory ArticleNode.fromJson(Map<String, dynamic> json) {
    return ArticleNode(
      uuid: json['uuid'],
      title: json['title'],
      slug: json['slug'],
      content: json['content'],
      summary: json['summary'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      isAnonymous: json['isAnonymous'],
      isOwner: json['isOwner'],
      isSerialized: json['isSerialized'],
      scoreInfo: json['scoreInfo'],
      articleType: json['articleType'],
      thumbnail: json['thumbnail'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      isLeetcode: json['isLeetcode'],
      canSee: json['canSee'],
      canEdit: json['canEdit'],
      isMyFavorite: json['isMyFavorite'],
      myReactionType: json['myReactionType'],
      topicId: json['topicId'],
      hitCount: json['hitCount'],
      reactions: (json['reactions'] as List?)
              ?.map((e) => Reaction.fromJson(e))
              .toList() ??
          [],
      tags: (json['tags'] as List?)
          ?.map((e) => DiscussionTagsEntity.fromJson(e))
          .toList(),
      topic: json['topic'] != null ? Topic.fromJson(json['topic']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'slug': slug,
      'summary': summary,
      'author': author?.toJson(),
      'isOwner': isOwner,
      'isSerialized': isSerialized,
      'scoreInfo': scoreInfo,
      'articleType': articleType,
      'thumbnail': thumbnail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLeetcode': isLeetcode,
      'canSee': canSee,
      'canEdit': canEdit,
      'isAnonymous': isAnonymous,
      'status': status,
      'hitCount': hitCount,
      'tags': tags?.map((e) => e.toJson()).toList(),
      'topic': topic?.toJson(),
    };
  }
}

class Reaction {
  final int? count;
  final String? reactionType;

  Reaction({this.count, this.reactionType});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      count: json['count'],
      reactionType: json['reactionType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'reactionType': reactionType,
    };
  }
}

class Author {
  final String? realName;
  final String? userAvatar;
  final String? userSlug;
  final String? userName;
  final String? nameColor;
  final String? certificationLevel;
  final ActiveBadge? activeBadge;

  Author(
      {this.realName,
      this.userAvatar,
      this.userSlug,
      this.userName,
      this.nameColor,
      this.certificationLevel,
      this.activeBadge});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      realName: json['realName'],
      userAvatar: json['userAvatar'],
      userSlug: json['userSlug'],
      userName: json['userName'],
      nameColor: json['nameColor'],
      certificationLevel: json['certificationLevel'],
      activeBadge: json['activeBadge'] != null
          ? ActiveBadge.fromJson(json['activeBadge'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'realName': realName,
      'userAvatar': userAvatar,
    };
  }

  factory Author.fromAuthorEntity(AuthorEntity authorEntity) {
    return Author(
      userName: authorEntity.username,
      userAvatar: authorEntity.profile?.userAvatar,
      realName: authorEntity.profile?.realName,
    );
  }
}

class Topic {
  final int? id;
  final int? topLevelCommentCount;

  Topic({this.id, this.topLevelCommentCount});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      topLevelCommentCount: json['topLevelCommentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topLevelCommentCount': topLevelCommentCount,
    };
  }
}

class DiscussionTagsEntity {
  final String? name;
  final String? slug;
  final int? id;

  DiscussionTagsEntity({
    this.name,
    this.slug,
    this.id,
  });

  factory DiscussionTagsEntity.fromJson(Map<String, dynamic> json) {
    return DiscussionTagsEntity(
      name: json['name'],
      slug: json['slug'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'id': id,
    };
  }
}
