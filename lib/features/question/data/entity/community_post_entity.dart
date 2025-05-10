import 'package:codersgym/features/profile/data/entity/user_profile_entity.dart';

import '../../domain/model/community_solution_post.dart';

class CommunityPostEntity {
  int? id;
  int? voteCount;
  int? voteStatus;
  String? content;
  int? updationDate;
  int? creationDate;
  String? status;
  Null? isHidden;
  AuthorEntity? author;
  bool? authorIsModerator;
  bool? isOwnPost;

  CommunityPostEntity(
      {this.id,
      this.voteCount,
      this.voteStatus,
      this.content,
      this.updationDate,
      this.creationDate,
      this.status,
      this.isHidden,
      this.author,
      this.authorIsModerator,
      this.isOwnPost});

  CommunityPostEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voteCount = json['voteCount'];
    voteStatus = json['voteStatus'];
    content = json['content'];
    updationDate = json['updationDate'];
    creationDate = json['creationDate'];
    status = json['status'];
    isHidden = json['isHidden'];
    author = json['author'] != null
        ? new AuthorEntity.fromJson(json['author'])
        : null;
    authorIsModerator = json['authorIsModerator'];
    isOwnPost = json['isOwnPost'];
  }
}

class AuthorEntity {
  bool? isDiscussAdmin;
  bool? isDiscussStaff;
  String? username;
  Null? nameColor;
  BadgeNode? activeBadge;
  ProfileNode? profile;
  bool? isActive;

  AuthorEntity(
      {this.isDiscussAdmin,
      this.isDiscussStaff,
      this.username,
      this.nameColor,
      this.activeBadge,
      this.profile,
      this.isActive});

  AuthorEntity.fromJson(Map<String, dynamic> json) {
    isDiscussAdmin = json['isDiscussAdmin'];
    isDiscussStaff = json['isDiscussStaff'];
    username = json['username'];
    nameColor = json['nameColor'];
    activeBadge = json['activeBadge'] != null
        ? new BadgeNode.fromJson(json['activeBadge'])
        : null;
    profile =
        json['profile'] != null ? ProfileNode.fromJson(json['profile']) : null;
    isActive = json['isActive'];
  }
}

extension CommunityPostEntityExt on CommunityPostEntity {
  CommunitySolutionPost toCommunitySolutionPost() {
    return CommunitySolutionPost(
      id: id,
      voteCount: voteCount,
      voteStatus: voteStatus,
      content: content,
      updationDate: updationDate,
      creationDate: creationDate,
      author: author != null
          ? CommunityPostAuthor(
              isDiscussAdmin: author!.isDiscussAdmin,
              isDiscussStaff: author!.isDiscussStaff,
              username: author!.username,
              activeBadge: author!.activeBadge?.toBadge(),
              profile: author!.profile?.toProfile(),
              isActive: author!.isActive)
          : null,
      authorIsModerator: authorIsModerator,
      isOwnPost: isOwnPost,
    );
  }
}
