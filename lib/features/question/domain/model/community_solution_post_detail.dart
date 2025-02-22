import 'package:codersgym/features/question/domain/model/community_solution_post.dart';

class CommunitySolutionPostDetail {
  final int? id;
  final int? viewCount;
  final int? topLevelCommentCount;
  final bool? subscribed;
  final String? title;
  final bool? pinned;
  final List<SolutionTag>? solutionTags;
  final bool? hideFromTrending;
  final int? commentCount;
  final bool? isFavorite;
  final CommunitySolutionPost? post;

  CommunitySolutionPostDetail({
    required this.id,
    required this.viewCount,
    required this.topLevelCommentCount,
    required this.subscribed,
    required this.title,
    required this.pinned,
    required this.solutionTags,
    required this.hideFromTrending,
    required this.commentCount,
    required this.isFavorite,
    required this.post,
  });
  CommunitySolutionPostDetail copyWith({
    int? id,
    int? viewCount,
    int? topLevelCommentCount,
    bool? subscribed,
    String? title,
    bool? pinned,
    List<SolutionTag>? solutionTags,
    bool? hideFromTrending,
    int? commentCount,
    bool? isFavorite,
    CommunitySolutionPost? post,
  }) {
    return CommunitySolutionPostDetail(
      id: id ?? this.id,
      viewCount: viewCount ?? this.viewCount,
      topLevelCommentCount: topLevelCommentCount ?? this.topLevelCommentCount,
      subscribed: subscribed ?? this.subscribed,
      title: title ?? this.title,
      pinned: pinned ?? this.pinned,
      solutionTags: solutionTags ?? this.solutionTags,
      hideFromTrending: hideFromTrending ?? this.hideFromTrending,
      commentCount: commentCount ?? this.commentCount,
      isFavorite: isFavorite ?? this.isFavorite,
      post: post ?? this.post,
    );
  }
}

class SolutionTag {
  final String? name;
  final String? slug;
  final int? count;

  SolutionTag({
    this.name,
    this.slug,
    this.count,
  });
}
