import 'package:equatable/equatable.dart';

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
      questionId: json['questionId'],
      titleSlug: json['titleSlug'],
      difficulty: json['difficulty'],
      acRate: json['acRate']?.toDouble(),
      paidOnly: json['paidOnly'],
      frontendQuestionId: json['frontendQuestionId'],
      hasVideoSolution: json['hasVideoSolution'],
      hasSolution: json['hasSolution'],
      content: json['content'],
      status: json['status'] != null
          ? QuestionStatus.values.firstWhere(
              (e) => e.toString() == 'QuestionStatus.${json['status']}')
          : null,
      hints: (json['hints'] as List<dynamic>?)?.cast<String>(),
      topicTags: (json['topicTags'] as List<dynamic>?)
          ?.map((v) => TopicTags.fromJson(v as Map<String, dynamic>))
          .toList(),
      codeSnippets: (json['codeSnippets'] as List<dynamic>?)
          ?.map((v) => CodeSnippet.fromJson(v as Map<String, dynamic>))
          .toList(),
      exampleTestCases: (json['exampleTestCases'] as List<dynamic>?)
          ?.map((v) => TestCase.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questionId': questionId,
      'titleSlug': titleSlug,
      'difficulty': difficulty,
      'acRate': acRate,
      'paidOnly': paidOnly,
      'frontendQuestionId': frontendQuestionId,
      'hasVideoSolution': hasVideoSolution,
      'hasSolution': hasSolution,
      'content': content,
      'status': status?.toString().split('.').last,
      'hints': hints,
      'topicTags': topicTags?.map((v) => v.toJson()).toList(),
      'codeSnippets': codeSnippets?.map((v) => v.toJson()).toList(),
      'exampleTestCases': exampleTestCases?.map((v) => v.toJson()).toList(),
    };
  }

  Map<String, Object> toAnalyticsMap() {
    return {
      "questionId": questionId ?? '',
      "title": title ?? '',
      "titleSlug": titleSlug ?? '',
    };
  }

  @override
  String toString() {
    return 'Question{questionId: $frontendQuestionId, title: $title}';
  }
}

class TopicTags extends Equatable {
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

  @override
  List<Object?> get props => [id];
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

  String get value {
    return switch (this) {
      QuestionStatus.accepted => "SOLVED",
      QuestionStatus.notAccepted => "ATTEMPTED",
      QuestionStatus.unattempted => "TO_DO",
    };
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

  factory CodeSnippet.fromJson(Map<String, dynamic> json) {
    return CodeSnippet(
      code: json['code'],
      lang: json['lang'],
      langSlug: json['langSlug'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'lang': lang,
      'langSlug': langSlug,
    };
  }
}

class TestCase {
  final List<String> inputs;

  TestCase({
    required this.inputs,
  });

  TestCase copy() {
    return TestCase(
      inputs: List.from(inputs),
    );
  }

  factory TestCase.fromJson(Map<String, dynamic> json) {
    return TestCase(
      inputs: (json['inputs'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inputs': inputs,
    };
  }

  @override
  String toString() {
    return 'TestCase{inputs: $inputs}';
  }
}
