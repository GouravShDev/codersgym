class Question {
  final String? title;
  final String? questionId;
  final String? titleSlug;
  final String? difficulty;
  final double? acRate;
  final bool? paidOnly;
  final String? frontendQuestionId;
  final bool? hasVideoSolution;
  final bool? hasSolution;
  final List<TopicTags>? topicTags;
  final String? content;
  final QuestionStatus? status;
  final List<String>? hints;
  final List<CodeSnippet>? codeSnippets;
  final List<TestCase>? exampleTestCases;

  const Question({
    this.title,
    this.questionId,
    this.titleSlug,
    this.difficulty,
    this.acRate,
    this.paidOnly,
    this.frontendQuestionId,
    this.hasVideoSolution,
    this.hasSolution,
    this.topicTags,
    this.content,
    this.status,
    this.hints,
    this.codeSnippets,
    this.exampleTestCases,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json['title'],
      titleSlug: json['titleSlug'],
      difficulty: json['difficulty'],
      acRate: json['acRate']?.toDouble(),
      paidOnly: json['paidOnly'],
      frontendQuestionId: json['frontendQuestionId'],
      hasVideoSolution: json['hasVideoSolution'],
      hasSolution: json['hasSolution'],
      content: json['content'],
      topicTags: (json['topicTags'] as List<dynamic>?)
          ?.map((v) => TopicTags.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'titleSlug': titleSlug,
      'difficulty': difficulty,
      'acRate': acRate,
      'paidOnly': paidOnly,
      'frontendQuestionId': frontendQuestionId,
      'hasVideoSolution': hasVideoSolution,
      'hasSolution': hasSolution,
      'content': content,
      'topicTags': topicTags?.map((v) => v.toJson()).toList(),
    };
  }
}

class TopicTags {
  final String? name;
  final String? id;
  final String? slug;

  const TopicTags({this.name, this.id, this.slug});

  factory TopicTags.fromJson(Map<String, dynamic> json) {
    return TopicTags(
      name: json['name'],
      id: json['id'],
      slug: json['slug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'slug': slug,
    };
  }
}

enum QuestionStatus { accepted, notAccepted, unattempted }

extension QuestionStatusExtension on QuestionStatus {
  String get description {
    switch (this) {
      case QuestionStatus.accepted:
        return "Accepted";
      case QuestionStatus.notAccepted:
        return "Attempted";
      case QuestionStatus.unattempted:
        return "Unattempted";
    }
  }
}

class CodeSnippet {
  final String? code;
  final String? lang;
  final String? langSlug;

  CodeSnippet({
    this.code,
    this.lang,
    this.langSlug,
  });
}

class TestCase {
  final List<String> inputs;

  TestCase({
    required this.inputs,
  });
}
