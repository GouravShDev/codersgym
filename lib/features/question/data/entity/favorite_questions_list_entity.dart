import 'package:codersgym/features/question/data/entity/question_entity.dart';

class FavoriteQuestionsListEntity {
  FavoriteQuestions? favoriteQuestionList;

  FavoriteQuestionsListEntity({this.favoriteQuestionList});

  FavoriteQuestionsListEntity.fromJson(Map<String, dynamic> json) {
    favoriteQuestionList = json['favoriteQuestionList'] != null
        ? FavoriteQuestions.fromJson(json['favoriteQuestionList'])
        : null;
  }
}

class FavoriteQuestions {
  int? total;
  List<QuestionNodeEntity>? questions;

  FavoriteQuestions({this.total, this.questions});

  FavoriteQuestions.fromJson(Map<String, dynamic> json) {
    total = json['totalLength'];
    if (json['questions'] != null) {
      questions = <QuestionNodeEntity>[];
      json['questions'].forEach((v) {
        questions!.add(QuestionNodeEntity.fromJson(v));
      });
    }
  }
}
