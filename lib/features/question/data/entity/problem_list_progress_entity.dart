import 'package:codersgym/features/question/domain/model/problem_list_progress.dart';

class ProblemListProgressEntity {
  final List<QuestionCountEntity>? numAcceptedQuestions;
  final List<QuestionCountEntity>? numFailedQuestions;
  final List<QuestionCountEntity>? numUntouchedQuestions;
  final List<UserSessionBeatsEntity>? userSessionBeatsPercentage;

  ProblemListProgressEntity({
    this.numAcceptedQuestions,
    this.numFailedQuestions,
    this.numUntouchedQuestions,
    this.userSessionBeatsPercentage,
  });

  factory ProblemListProgressEntity.fromJson(Map<String, dynamic> json) {
    final data = json['favoriteUserQuestionProgressV2'];
    return ProblemListProgressEntity(
      numAcceptedQuestions: (data?['numAcceptedQuestions'] as List?)
          ?.map((e) => QuestionCountEntity.fromJson(e))
          .toList(),
      numFailedQuestions: (data?['numFailedQuestions'] as List?)
          ?.map((e) => QuestionCountEntity.fromJson(e))
          .toList(),
      numUntouchedQuestions: (data?['numUntouchedQuestions'] as List?)
          ?.map((e) => QuestionCountEntity.fromJson(e))
          .toList(),
      userSessionBeatsPercentage: (data?['userSessionBeatsPercentage'] as List?)
          ?.map((e) => UserSessionBeatsEntity.fromJson(e))
          .toList(),
    );
  }
}

class QuestionCountEntity {
  final int? count;
  final String? difficulty;

  QuestionCountEntity({this.count, this.difficulty});

  factory QuestionCountEntity.fromJson(Map<String, dynamic> json) {
    return QuestionCountEntity(
      count: json['count'],
      difficulty: json['difficulty'],
    );
  }
}

class UserSessionBeatsEntity {
  final String? difficulty;
  final double? percentage;

  UserSessionBeatsEntity({this.difficulty, this.percentage});

  factory UserSessionBeatsEntity.fromJson(Map<String, dynamic> json) {
    return UserSessionBeatsEntity(
      difficulty: json['difficulty'],
      percentage: (json['percentage'] as num?)?.toDouble(),
    );
  }
}

extension ProblemListProgressMapper on ProblemListProgressEntity {
  ProblemListProgress toProblemListProgress() {
    num getTotal(String difficulty) {
      return (numAcceptedQuestions
                  ?.where((q) => q.difficulty == difficulty)
                  .fold(0, (sum, q) => (sum) + (q.count ?? 0)) ??
              0) +
          (numFailedQuestions
                  ?.where((q) => q.difficulty == difficulty)
                  .fold(0, (sum, q) => (sum ?? 0) + (q.count ?? 0)) ??
              0) +
          (numUntouchedQuestions
                  ?.where((q) => q.difficulty == difficulty)
                  .fold(0, (sum, q) => (sum ?? 0) + (q.count ?? 0)) ??
              0);
    }

    num getSolved(String difficulty) {
      return numAcceptedQuestions
              ?.where((q) => q.difficulty == difficulty)
              .fold(0, (sum, q) => (sum ?? 0) + (q.count ?? 0)) ??
          0;
    }

    double getUserBeats(String difficulty) {
      return userSessionBeatsPercentage
              ?.firstWhere((q) => q.difficulty == difficulty,
                  orElse: () => UserSessionBeatsEntity(percentage: 0.0))
              .percentage ??
          0.0;
    }

    return ProblemListProgress(
      totalEasy: getTotal("EASY").toInt(),
      totalMedium: getTotal("MEDIUM").toInt(),
      totalHard: getTotal("HARD").toInt(),
      solvedEasy: getSolved("EASY").toInt(),
      solvedMedium: getSolved("MEDIUM").toInt(),
      solvedHard: getSolved("HARD").toInt(),
      userBeatsEasy: getUserBeats("EASY"),
      userBeatsMedium: getUserBeats("MEDIUM"),
      userBeatsHard: getUserBeats("HARD"),
    );
  }
}
