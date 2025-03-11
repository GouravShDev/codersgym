import 'package:codersgym/features/question/presentation/widgets/question_status_icon.dart';
import 'package:flutter/material.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/widgets/question_difficulty_text.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.onTap,
    this.backgroundColor,
    this.hideDifficulty,
  });

  final Question question;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final bool? hideDifficulty;

  factory QuestionCard.empty() {
    return QuestionCard(
      question: const Question(),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 4,
      // color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            ("${question.frontendQuestionId}. ") +
                                (question.title ?? "No Title"),
                            style: textTheme.titleMedium,
                          ),
                        ),
                        if (question.paidOnly == true)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Premium',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(1.2, 1.0),
                                      blurRadius: 3.0,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (question.status != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: QuestionStatusIcon(
                        status: question.status!,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuestionDifficultyText(
                    key: ValueKey(hideDifficulty),
                    question,
                    hideDifficulty: hideDifficulty ?? true,
                  ),
                  Row(
                    children: [
                      const Text("Acceptance: "),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${question.acRate?.toStringAsFixed(2) ?? ""}%",
                        style: textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
