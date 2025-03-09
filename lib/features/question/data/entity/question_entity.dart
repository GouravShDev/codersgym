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
    frontendQuestionId =
        json['frontendQuestionId'] ?? json['questionFrontendId'];
    hasVideoSolution = json['hasVideoSolution'];
    hasSolution = json['hasSolution'];
    content = json['content'];
    questionId = json['questionId'] ?? (json['id'] as int?)?.toString();
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
      // Multiplying 100 because we are getting accuracy rate in between 0 - 1
      // leetcode v2 apis but previously we were getting 0-100.
      // Need to find better way to handle this
      acRate: (acRate != null && acRate! < 1) ? (acRate! * 100) : acRate,
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
    case "ac" || "SOLVED":
      return QuestionStatus.accepted;
    case "notac" || "ATTEMPTED":
      return QuestionStatus.notAccepted;
    case "TO_DO" || null:
      return QuestionStatus.unattempted;
    default:
      throw ArgumentError("Invalid JSON value for QuestionStatus: $jsonValue");
  }
}
