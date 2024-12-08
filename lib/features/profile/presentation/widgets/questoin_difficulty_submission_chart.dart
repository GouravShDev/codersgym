import 'package:codersgym/app.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestionDifficultySubmissionChart extends StatelessWidget {
  final int easyCount;
  final int mediumCount;
  final int hardCount;
  final int totalEasyCount;
  final int totalMediumCount;
  final int totalHardCount;

  const QuestionDifficultySubmissionChart({
    super.key,
    required this.easyCount,
    required this.mediumCount,
    required this.hardCount,
    required this.totalEasyCount,
    required this.totalMediumCount,
    required this.totalHardCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final totalSolvedQuestions = easyCount + mediumCount + hardCount;
    final totalQuestions = totalEasyCount + totalMediumCount + totalHardCount;
    const lineWidth = 12.0;
    const animationDuration = 1500;
    const easyPercentageIndicatorRadius = 70.0;
    const mediumPercentageIndicatorRadius =
        easyPercentageIndicatorRadius + lineWidth + 2;
    const hardPercentageIndicatorRadius =
        mediumPercentageIndicatorRadius + lineWidth + 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Questions Solved: ",
              style: textTheme.titleMedium?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              "$totalSolvedQuestions/ $totalQuestions",
              style: textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Hard Progress (outermost layer)
                  CircularPercentIndicator(
                    radius: hardPercentageIndicatorRadius,
                    animateFromLastPercent: true,
                    lineWidth: lineWidth,
                    percent:
                        totalHardCount == 0 ? 0 : hardCount / totalHardCount,
                    animation: true,
                    animationDuration: animationDuration,
                    restartAnimation: true,
                    curve: Curves.easeInOut,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Theme.of(context).focusColor,
                    progressColor: Theme.of(context).colorScheme.error,
                  ),
                  // Medium Progress (middle layer)
                  CircularPercentIndicator(
                    radius: mediumPercentageIndicatorRadius,
                    lineWidth: lineWidth,
                    percent: totalMediumCount == 0
                        ? 0
                        : mediumCount / totalMediumCount,
                    animation: true,
                    animationDuration: animationDuration,
                    curve: Curves.easeInOut,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                    progressColor: Theme.of(context).colorScheme.warningColor,
                  ),
                  // Easy Progress (innermost layer)
                  CircularPercentIndicator(
                    radius: easyPercentageIndicatorRadius,
                    lineWidth: lineWidth,
                    percent:
                        totalEasyCount == 0 ? 0 : easyCount / totalEasyCount,
                    animation: true,
                    animationDuration: animationDuration,
                    curve: Curves.easeInOut,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    progressColor:
                        Theme.of(context).colorScheme.successColorAccent,
                  ),
                  // Center Text Display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$totalSolvedQuestions",
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Total",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(
                    label: "Easy",
                    color: Color(0xff1ABBBB),
                    solvedQuestionCount: easyCount,
                    totalQuestionCount: totalEasyCount,
                  ),
                  _buildLegendItem(
                    label: "Medium",
                    color: Color(0xffFEB600),
                    solvedQuestionCount: mediumCount,
                    totalQuestionCount: totalMediumCount,
                  ),
                  _buildLegendItem(
                    label: "Hard",
                    color: Color(0xffF53836),
                    solvedQuestionCount: hardCount,
                    totalQuestionCount: totalHardCount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required String label,
    required Color color,
    required int solvedQuestionCount,
    required int totalQuestionCount,
  }) {
    return SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(solvedQuestionCount.toString() +
                  "/" +
                  totalQuestionCount.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
