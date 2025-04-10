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
      hasNextPage: json['ugcArticleDiscussionArticles']['pageInfo']['hasNextPage'],
      articles: (json['ugcArticleDiscussionArticles']['edges'] as List?)?.map((e) => ArticleNode.fromJson(e['node'])).toList(),
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

class ArticleNode {
  final String? uuid;
  final String? title;
  final String? slug;
  final String? summary;
  final Author? author;
  final bool? isAnonymous;
  final String? status;
  final int? hitCount;
  final List<Tag>? tags;
  final int? topLevelCommentCount;

  ArticleNode({
    this.uuid,
    this.title,
    this.slug,
    this.summary,
    this.author,
    this.isAnonymous,
    this.status,
    this.hitCount,
    this.tags,
    this.topLevelCommentCount,
  });

  factory ArticleNode.fromJson(Map<String, dynamic> json) {
    return ArticleNode(
      uuid: json['uuid'],
      title: json['title'],
      slug: json['slug'],
      summary: json['summary'],
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      isAnonymous: json['isAnonymous'],
      status: json['status'],
      hitCount: json['hitCount'],
      tags: (json['tags'] as List?)?.map((e) => Tag.fromJson(e)).toList(),
      topLevelCommentCount: json['topic']?['topLevelCommentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'slug': slug,
      'summary': summary,
      'author': author?.toJson(),
      'isAnonymous': isAnonymous,
      'status': status,
      'hitCount': hitCount,
      'tags': tags?.map((e) => e.toJson()).toList(),
      'topic': {'topLevelCommentCount': topLevelCommentCount},
    };
  }
}

class Author {
  final String? realName;
  final String? userAvatar;

  Author({this.realName, this.userAvatar});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      realName: json['realName'],
      userAvatar: json['userAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'realName': realName,
      'userAvatar': userAvatar,
    };
  }
}

class Tag {
  final String? name;
  final String? slug;

  Tag({this.name, this.slug});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
    };
  }
}
