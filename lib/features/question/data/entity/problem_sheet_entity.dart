import 'package:codersgym/features/question/domain/model/problem_sheet.dart';

class ProblemSheetsEntity {
  final List<ProblemSheetEntity> list;

  ProblemSheetsEntity({required this.list});

  factory ProblemSheetsEntity.fromJson(Map<String, dynamic> json) {
    return ProblemSheetsEntity(
      list: (json['list'] as List<dynamic>)
          .map((e) => ProblemSheetEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list.map((e) => e.toJson()).toList(),
    };
  }

  map(Function(dynamic e) param0) {}
}

class ProblemSheetEntity {
  final String name;
  final String slug;
  final String description;
  final String author;

  ProblemSheetEntity({
    required this.name,
    required this.slug,
    required this.description,
    required this.author,
  });

  factory ProblemSheetEntity.fromJson(Map<String, dynamic> json) {
    return ProblemSheetEntity(
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'author': author,
    };
  }
}

extension ProblemSheetEntityExt on ProblemSheetEntity {
  ProblemSheet toProblemSheet() {
    return ProblemSheet(
      name: name,
      slug: slug,
      description: description,
      author: author,
    );
  }
}
