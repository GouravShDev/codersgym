class Solution {
  final String? id;
  final String? title;
  final String? content;
  final String? contentTypeId;
  final bool? paidOnly;
  final bool? hasVideoSolution;
  final bool? paidOnlyVideo;
  final bool? canSeeDetail;
  final int? topicId;

  Solution({
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
  Solution copyWith({
    String? id,
    String? title,
    String? content,
    String? contentTypeId,
    bool? paidOnly,
    bool? hasVideoSolution,
    bool? paidOnlyVideo,
    bool? canSeeDetail,
    int? topicId,
  }) {
    return Solution(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      contentTypeId: contentTypeId ?? this.contentTypeId,
      paidOnly: paidOnly ?? this.paidOnly,
      hasVideoSolution: hasVideoSolution ?? this.hasVideoSolution,
      paidOnlyVideo: paidOnlyVideo ?? this.paidOnlyVideo,
      canSeeDetail: canSeeDetail ?? this.canSeeDetail,
      topicId: topicId ?? this.topicId,
    );
  }
}
