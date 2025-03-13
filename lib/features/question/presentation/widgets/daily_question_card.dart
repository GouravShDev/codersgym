import 'package:codersgym/features/common/widgets/app_countdown_timer.dart';
import 'package:codersgym/features/common/widgets/loading_dots.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';

class DailyQuestionCard extends StatelessWidget {
  const DailyQuestionCard({
    super.key,
    required this.question,
    required this.onSolveTapped,
    this.isFetching = false,
    this.currentTime,
  });

  final Question question;
  final VoidCallback onSolveTapped;
  final bool isFetching;
  final DateTime? currentTime;

  factory DailyQuestionCard.empty() {
    // Set default expiry time to end of current day
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return DailyQuestionCard(
      question: const Question(
        title: 'two sum',
        difficulty: 'easy',
      ),
      onSolveTapped: () {},
      currentTime: endOfDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Challenge",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                    ),
                    // Add the countdown timer
                    if (currentTime != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCountdownTimer(
                              referenceTime: currentTime!.toLocal(),
                              targetTime: getLeetCodeDailyChallengeResetTime()
                                  .toLocal(),
                              timeStyle: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              labelStyle: textTheme.labelSmall?.copyWith(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  ("${question.frontendQuestionId}. ") +
                      (question.title ?? "No Title"),
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuestionDifficultyText(question),
                    ElevatedButton(
                      onPressed: onSolveTapped,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: isFetching
                            ? Theme.of(context).primaryColor.withOpacity(0.7)
                            : null,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isFetching
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Loading"),
                                  const SizedBox(width: 8),
                                  LoadingDots(),
                                ],
                              )
                            : const Text("Solve"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

DateTime getLeetCodeDailyChallengeResetTime() {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day).add(const Duration(days: 1));
}
