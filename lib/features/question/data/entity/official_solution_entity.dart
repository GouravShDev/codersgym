import 'package:codersgym/features/question/data/entity/solution_entity.dart';

class OfficialSolutionEntity {
  QuestionWithSolutionEntity? question;

  OfficialSolutionEntity({this.question});

  OfficialSolutionEntity.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? QuestionWithSolutionEntity.fromJson(json['question'])
        : null;
  }

}

class QuestionWithSolutionEntity {
  SolutionEntity? solution;

  QuestionWithSolutionEntity({this.solution});

  QuestionWithSolutionEntity.fromJson(Map<String, dynamic> json) {
    solution = json['solution'] != null
        ? SolutionEntity.fromJson(json['solution'])
        : null;
  }


}
