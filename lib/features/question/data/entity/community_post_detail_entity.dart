import 'package:codersgym/features/profile/data/entity/user_profile_entity.dart';
import 'package:codersgym/features/question/data/entity/community_post_entity.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';

class CommunityPostDetailEntity {
  int? id;
  int? viewCount;
  int? topLevelCommentCount;
  bool? subscribed;
  String? title;
  bool? pinned;
  List<SolutionTagEntity>? solutionTags;
  bool? hideFromTrending;
  int? commentCount;
  bool? isFavorite;
  CommunityPostEntity? post;

  CommunityPostDetailEntity(
      {this.id,
      this.viewCount,
      this.topLevelCommentCount,
      this.subscribed,
      this.title,
      this.pinned,
      this.solutionTags,
      this.hideFromTrending,
      this.commentCount,
      this.isFavorite,
      this.post});

  CommunityPostDetailEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viewCount = json['viewCount'];
    topLevelCommentCount = json['topLevelCommentCount'];
    subscribed = json['subscribed'];
    title = json['title'];
    pinned = json['pinned'];
    if (json['solutionTags'] != null) {
      solutionTags = <SolutionTagEntity>[];
      json['solutionTags'].forEach((v) {
        solutionTags!.add(SolutionTagEntity.fromJson(v));
      });
    }
    hideFromTrending = json['hideFromTrending'];
    commentCount = json['commentCount'];
    isFavorite = json['isFavorite'];
    post = json['post'] != null
        ? CommunityPostEntity.fromJson(json['post'])
        : null;
  }
}

class SolutionTagEntity {
  String? name;
  String? slug;
  int? count;

  SolutionTagEntity({this.name, this.slug});

  SolutionTagEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['slug'] = slug;
    data['count'] = count;
    return data;
  }
}

extension SolutionTagEntityExt on SolutionTagEntity {
  SolutionTag toSolutionTag() {
    return SolutionTag(
      name: name,
      slug: slug,
      count: count,
    );
  }
}

extension CommunityPostDetailEntityExt on CommunityPostDetailEntity {
  CommunitySolutionPostDetail toCommunitySolutionPostDetail() {
    return CommunitySolutionPostDetail(
      id: id,
      viewCount: viewCount,
      topLevelCommentCount: topLevelCommentCount,
      subscribed: subscribed,
      title: title,
      pinned: pinned,
      solutionTags: solutionTags?.map((e) => e.toSolutionTag()).toList(),
      hideFromTrending: hideFromTrending,
      commentCount: commentCount,
      isFavorite: isFavorite,
      post: post?.toCommunitySolutionPost(),
    );
  }
}
