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
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
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
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.successColor,
              size: 80,
            ),
            const SizedBox(height: 4),
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
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatCard(
          context,
          title: "Runtime",
          icon: Icons.timelapse_outlined,
          value: '${result.runTime?.replaceFirst('ms', '') ?? 'N/A'} ms',
          percentile:
              '${result.runtimePercentile?.toStringAsFixed(2) ?? 'N/A'}%',
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          context,
          title: "Memory",
          icon: Icons.memory_outlined,
          value: '${result.statusMemory?.replaceFirst('mb', '') ?? 'N/A'} MB',
          percentile:
              '${result.memoryPercentile?.toStringAsFixed(2) ?? 'N/A'}%',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String value,
    required String percentile,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: Theme.of(context).focusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Percentile",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  percentile,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
