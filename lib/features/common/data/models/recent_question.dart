import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:hive/hive.dart';

part 'recent_question.g.dart';

@HiveType(typeId: 0)
class RecentQuestion extends HiveObject {
  @HiveField(0)
  final String frontendQuestionId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String titleSlug;

  @HiveField(3)
  final String difficulty;

  @HiveField(4)
  final double acRate;

  @HiveField(5)
  QuestionStatus status;

  @HiveField(6)
  DateTime lastOpened;

  RecentQuestion({
    required this.frontendQuestionId,
    required this.title,
    required this.titleSlug,
    required this.difficulty,
    required this.acRate,
    required this.status,
    required this.lastOpened,
  });
}

class QuestionStatusAdapter extends TypeAdapter<QuestionStatus> {
  @override
  final int typeId = 1; // Unique across your app

  @override
  QuestionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestionStatus.accepted;
      case 1:
        return QuestionStatus.notAccepted;
      case 2:
        return QuestionStatus.unattempted;
      default:
        return QuestionStatus.unattempted;
    }
  }

  @override
  void write(BinaryWriter writer, QuestionStatus obj) {
    switch (obj) {
      case QuestionStatus.accepted:
        writer.writeByte(0);
        break;
      case QuestionStatus.notAccepted:
        writer.writeByte(1);
        break;
      case QuestionStatus.unattempted:
        writer.writeByte(2);
        break;
    }
  }
}

