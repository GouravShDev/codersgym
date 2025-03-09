import 'package:flutter/material.dart';

class QuestionDifficultyLegend extends StatelessWidget {
  final int easyCount;
  final int mediumCount;
  final int hardCount;
  final int totalEasyCount;
  final int totalMediumCount;
  final int totalHardCount;
  final bool isHorizontal; // New parameter to control layout direction

  const QuestionDifficultyLegend({
    super.key,
    required this.easyCount,
    required this.mediumCount,
    required this.hardCount,
    required this.totalEasyCount,
    required this.totalMediumCount,
    required this.totalHardCount,
    this.isHorizontal = false, // Default to vertical (column) layout
  });

  @override
  Widget build(BuildContext context) {
    // Use a Row or Column based on isHorizontal parameter
    return isHorizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildLegendItems(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildLegendItems(),
          );
  }

  // Extract the legend items to a separate method to reuse in both layouts
  List<Widget> _buildLegendItems() {
    return [
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
    ];
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
