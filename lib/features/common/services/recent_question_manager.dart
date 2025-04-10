import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/features/common/data/models/recent_question.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:hive/hive.dart';

class RecentQuestionManager {
  static const String boxName = 'recent_questions';

  Future<void> init() async {
    Hive.registerAdapter(RecentQuestionAdapter());
    Hive.registerAdapter(QuestionStatusAdapter());
    await Hive.openBox<RecentQuestion>(boxName);
  }

static RecentQuestion fromFullQuestion(Question q) {
  return RecentQuestion(
    frontendQuestionId: q.frontendQuestionId ?? '',
    title: q.title ?? '',
    titleSlug: q.titleSlug ?? '',
    difficulty: q.difficulty ?? '',
    acRate: q.acRate ?? 0.0,
    status: q.status ?? QuestionStatus.unattempted,
    lastOpened: DateTime.now(),
  );
}

  Future<Result<void, Exception>> addOrUpdateQuestion(
      RecentQuestion question) async {
    try {
      final box = Hive.box<RecentQuestion>(boxName);

      final existingKey = box.keys.firstWhere(
        (key) =>
            box.get(key)?.frontendQuestionId == question.frontendQuestionId,
        orElse: () => null,
      );

      if (existingKey != null) {
        final existing = box.get(existingKey);
        if (existing != null) {
          existing
            ..status = question.status
            ..lastOpened = question.lastOpened;
          await existing.save();
          await box.delete(existingKey);
          await box.add(existing);
        }
      } else {
        await box.add(question);
      }

      if (box.length > 10) {
        final keysToDelete = box.keys.take(box.length - 10).toList();
        await box.deleteAll(keysToDelete);
      }

      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to update recent question: $e'));
    }
  }

  Future<Result<void, Exception>> updateStatus(
      String frontendQuestionId, QuestionStatus status) async {
    try {
      final box = Hive.box<RecentQuestion>(boxName);

      final key = box.keys.firstWhere(
        (key) => box.get(key)?.frontendQuestionId == frontendQuestionId,
        orElse: () => null,
      );

      if (key != null) {
        final question = box.get(key);
        if (question != null) {
          question.status = status;
          await question.save();
          return const Success(null);
        }
      }

      return Failure(Exception("Question not found"));
    } catch (e) {
      return Failure(Exception('Failed to update question status: $e'));
    }
  }

  Future<Result<List<RecentQuestion>, Exception>> getRecentQuestions() async {
    try {
      final box = Hive.box<RecentQuestion>(boxName);
      final questions = box.values.toList();
      questions.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
      return Success(questions);
    } catch (e) {
      return Failure(Exception('Failed to fetch recent questions: $e'));
    }
  }
  Future<Result<void, Exception>> clearRecentQuestions() async {
  try {
    final box = Hive.box<RecentQuestion>(boxName);
    await box.clear();
    return const Success(null);
  } catch (e) {
    return Failure(Exception('Failed to clear recent questions: $e'));
  }
}

}

