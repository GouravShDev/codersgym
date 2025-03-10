import 'package:codersgym/features/common/widgets/app_animated_progressbar.dart';
import 'package:flutter/material.dart';

class ProblemSheetProgressWidget extends StatefulWidget {
  final int solvedCount;
  final int totalCount;
  final Color progressColor;
  final double height;
  final Duration animationDuration;
  final BorderRadius? borderRadius;
  final bool showPercentage;

  const ProblemSheetProgressWidget({
    super.key,
    required this.solvedCount,
    required this.totalCount,
    this.progressColor = Colors.blue,
    this.height = 12.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.borderRadius,
    this.showPercentage = true,
  });

  @override
  State<ProblemSheetProgressWidget> createState() =>
      _ProblemSheetProgressWidgetState();
}

class _ProblemSheetProgressWidgetState
    extends State<ProblemSheetProgressWidget> {
  // Force animation to run by creating a key
  Key _progressBarKey = UniqueKey();

  @override
  void didUpdateWidget(ProblemSheetProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.solvedCount != widget.solvedCount ||
        oldWidget.totalCount != widget.totalCount) {
      setState(() {
        _progressBarKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        widget.totalCount > 0 ? widget.solvedCount / widget.totalCount : 0.0;
    final percentage = (progress * 100).toInt();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                if (widget.showPercentage)
                  Text(
                    '$percentage% · ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: widget.progressColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  '${widget.solvedCount}/${widget.totalCount} Questions',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppAnimatedProgressbar(
          key: _progressBarKey, // Use key to force rebuild
          progress: progress,
          progressColor: widget.progressColor,
          backgroundColor: theme.highlightColor,
          height: widget.height,
          animationDuration: widget.animationDuration,
          borderRadius: widget.borderRadius,
        ),
      ],
    );
  }
}
