import 'package:codersgym/features/question/domain/model/solution.dart';

class SolutionEntity {
  String? id;
  String? title;
  String? content;
  String? contentTypeId;
  bool? paidOnly;
  bool? hasVideoSolution;
  bool? paidOnlyVideo;
  bool? canSeeDetail;
  int? topicId;

  SolutionEntity({
    this.id,
    this.title,
    this.content,
    this.contentTypeId,
    this.paidOnly,
    this.hasVideoSolution,
    this.paidOnlyVideo,
    this.canSeeDetail,
    this.topicId,
  });

  SolutionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    contentTypeId = json['contentTypeId'];
    paidOnly = json['paidOnly'];
    hasVideoSolution = json['hasVideoSolution'];
    paidOnlyVideo = json['paidOnlyVideo'];
    canSeeDetail = json['canSeeDetail'];
    topicId = json['topic']?['id'];
  }

}

extension SolutionEntityExt on SolutionEntity {
  Solution toSolution() {
    return Solution(
      id: id,
      title: title,
      content: content,
      contentTypeId: contentTypeId,
      paidOnly: paidOnly,
      hasVideoSolution: hasVideoSolution,
      paidOnlyVideo: paidOnlyVideo,
      canSeeDetail: canSeeDetail,
      topicId: topicId,
    );
  }
}
