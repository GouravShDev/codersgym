import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';

class DiscussionArticle {
   final String? uuid;
  final String? title;
  final String? slug;
  final String? summary;
  final UserProfile? author;
  final bool? isAnonymous;
  final String? status;
  final int? hitCount;
  final List<Tag>? tags;
  final int? topLevelCommentCount;

  DiscussionArticle({required this.uuid, required this.title, required this.slug, required this.summary, required this.author, required this.isAnonymous, required this.status, required this.hitCount, required this.tags, required this.topLevelCommentCount});
}