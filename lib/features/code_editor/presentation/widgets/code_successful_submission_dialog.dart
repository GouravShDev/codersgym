import 'package:codersgym/app.dart';
import 'package:codersgym/core/theme/app_theme.dart';
import 'package:codersgym/features/code_editor/domain/model/code_execution_result.dart';
import 'package:flutter/material.dart';

class CodeSuccessfulSubmissionDialog extends StatelessWidget {
  final CodeExecutionResult result;

  const CodeSuccessfulSubmissionDialog({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.successColor,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              'Accepted',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.successColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildPerformanceStats(context),
            const SizedBox(height: 20),
            _buildTestcaseResults(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn('Runtime', '${result.runTime ?? 'N/A'}'),
        _buildStatColumn('Memory', '${result.statusMemory ?? 'N/A'}'),
        _buildStatColumn(
          'Percentile',
          'RT: ${result.runtimePercentile?.toStringAsFixed(2) ?? 'N/A'}%\n'
              'Mem: ${result.memoryPercentile?.toStringAsFixed(2) ?? 'N/A'}%',
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTestcaseResults() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Case Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Total Test Cases: ${result.totalTestcases ?? 0}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Correct Test Cases: ${result.totalCorrect ?? 0}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
