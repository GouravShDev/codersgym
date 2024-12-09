import 'package:codersgym/features/question/domain/model/question.dart';

class QuestionNodeEntity {
  String? title;
  String? titleSlug;
  String? difficulty;
  String? questionId;
  double? acRate;
  bool? paidOnly;
  String? frontendQuestionId;
  bool? hasVideoSolution;
  bool? hasSolution;
  String? content;
  List<TopicTagsNodeEntity>? topicTags;
  List<String>? hints;
  Null? freqBar;
  bool? isFavor;
  String? status;
  List<CodeSnippetEntity>? codeSnippets;
  List<String>? exampleTestcaseList;
  QuestionNodeEntity({
    this.title,
    this.titleSlug,
    this.difficulty,
    this.acRate,
    this.paidOnly,
    this.frontendQuestionId,
    this.hasVideoSolution,
    this.hasSolution,
    this.topicTags,
    this.content,
    this.hints,
    this.status,
    this.codeSnippets,
    this.exampleTestcaseList,
  });

  QuestionNodeEntity.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    titleSlug = json['titleSlug'];
    difficulty = json['difficulty'];
    acRate = json['acRate']?.toDouble();
    paidOnly = json['paidOnly'];
    frontendQuestionId = json['frontendQuestionId'];
    hasVideoSolution = json['hasVideoSolution'];
    hasSolution = json['hasSolution'];
    content = json['content'];
    questionId = json['questionId'];
    if (json['hints'] != null) {
      hints = (json['hints'] as List)
          .map(
            (e) => e as String,
          )
          .toList();
    }
    status = json['status'];
    if (json['topicTags'] != null) {
      topicTags = [];
      json['topicTags'].forEach((v) {
        topicTags!.add(TopicTagsNodeEntity.fromJson(v));
      });
    }
    codeSnippets = json["codeSnippets"] == null
        ? []
        : List<CodeSnippetEntity>.from(
            json["codeSnippets"]!.map((x) => CodeSnippetEntity.fromJson(x)));
    exampleTestcaseList = json['exampleTestcaseList'] != null
        ? List.from(json['exampleTestcaseList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'titleSlug': titleSlug,
      'difficulty': difficulty,
      'acRate': acRate,
      'paidOnly': paidOnly,
      'content': content,
      'frontendQuestionId': frontendQuestionId,
      'hasVideoSolution': hasVideoSolution,
      'hasSolution': hasSolution,
      'status': status,
      'topicTags': topicTags?.map((v) => v.toJson()).toList(),
    };
  }
}

class TopicTagsNodeEntity {
  String? name;
  String? id;
  String? slug;

  TopicTagsNodeEntity({this.name, this.id, this.slug});

  TopicTagsNodeEntity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'slug': slug,
    };
  }
}

extension QuestionNodeEntityExt on QuestionNodeEntity {
  Question toQuestion() {
    return Question(
      title: title,
      questionId: questionId,
      titleSlug: titleSlug,
      difficulty: difficulty,
      acRate: acRate,
      paidOnly: paidOnly,
      frontendQuestionId: frontendQuestionId,
      hasVideoSolution: hasVideoSolution,
      hasSolution: hasSolution,
      content: content,
      topicTags: topicTags?.map((tag) => tag.toTopicTags()).toList(),
      status: _parseQuestionStatus(status),
      hints: hints,
      codeSnippets: codeSnippets
          ?.map((snippet) => snippet.toCodeSnippet())
          .toList(), // Mapping codeSnippets
      exampleTestCases: exampleTestcaseList?.map(
        (e) {
          final cases = e.split('\n');
          return TestCase(inputs: cases);
        },
      ).toList(),
    );
  }
}

class CodeSnippetEntity {
  final String? code;
  final String? lang;
  final String? langSlug;

  CodeSnippetEntity({
    this.code,
    this.lang,
    this.langSlug,
  });

  factory CodeSnippetEntity.fromJson(Map<String, dynamic> json) =>
      CodeSnippetEntity(
        code: json["code"],
        lang: json["lang"],
        langSlug: json["langSlug"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "lang": lang,
        "langSlug": langSlug,
      };
}

extension CodeSnippetEntityExt on CodeSnippetEntity {
  CodeSnippet toCodeSnippet() {
    return CodeSnippet(
        code: code, lang: lang, langSlug: langSlug); // Creating CodeSnippet
  }
}

extension TopicTagsNodeEntityExt on TopicTagsNodeEntity {
  TopicTags toTopicTags() {
    return TopicTags(id: id, name: name, slug: slug);
  }
}

QuestionStatus _parseQuestionStatus(String? jsonValue) {
  switch (jsonValue) {
    case "ac":
      return QuestionStatus.accepted;
    case "notac":
      return QuestionStatus.notAccepted;
    case null:
      return QuestionStatus.unattempted;
    default:
      throw ArgumentError("Invalid JSON value for QuestionStatus: $jsonValue");
  }
}
