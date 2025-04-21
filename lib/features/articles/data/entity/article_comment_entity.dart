import 'package:codersgym/features/question/data/entity/community_post_entity.dart';

import '../../../common/data/models/tag.dart';

class ArticleCommentEntity {
  final String? id;
  final bool? pinned;
  final String? pinnedBy;
  final CommunityPostEntity? post;
  final Tag? intentionTag;
  final int? numChildren;

  ArticleCommentEntity({
    required this.id,
    required this.pinned,
    this.pinnedBy,
    required this.post,
    this.intentionTag,
    required this.numChildren,
  });

  factory ArticleCommentEntity.fromJson(Map<String, dynamic> json) {
    return ArticleCommentEntity(
      id: json['id']?.toString(),
      pinned: json['pinned'] as bool?,
      pinnedBy: json['pinnedBy']?.toString(),
      post: json['post'] != null
          ? CommunityPostEntity.fromJson(json['post'])
          : null,
      intentionTag: json['intentionTag'] != null
          ? Tag.fromJson(json['intentionTag'])
          : null,
      numChildren: json['numChildren'] as int?,
    );
  }
}

class CommunityPostEntity {
  final String? id;
  final int? voteCount;
  final int? voteUpCount;
  final int? voteStatus;
  final String? content;
  final String? updationDate;
  final String? creationDate;
  final String? status;
  final bool? isHidden;
  final bool? anonymous;
  final AuthorEntity? author;
  final bool? authorIsModerator;
  final bool? isOwnPost;

  CommunityPostEntity({
    this.id,
    this.voteCount,
    this.voteUpCount,
    this.voteStatus,
    this.content,
    this.updationDate,
    this.creationDate,
    this.status,
    this.isHidden,
    this.anonymous,
    this.author,
    this.authorIsModerator,
    this.isOwnPost,
  });

  factory CommunityPostEntity.fromJson(Map<String, dynamic> json) {
    return CommunityPostEntity(
      id: json['id']?.toString(),
      voteCount: json['voteCount'] as int?,
      voteUpCount: json['voteUpCount'] as int?,
      voteStatus: json['voteStatus'] as int?,
      content: json['content']?.toString(),
      updationDate: json['updationDate']?.toString(),
      creationDate: json['creationDate']?.toString(),
      status: json['status']?.toString(),
      isHidden: json['isHidden'] as bool?,
      anonymous: json['anonymous'] as bool?,
      author: json['author'] != null
          ? AuthorEntity.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      authorIsModerator: json['authorIsModerator'] as bool?,
      isOwnPost: json['isOwnPost'] as bool?,
    );
  }
}
