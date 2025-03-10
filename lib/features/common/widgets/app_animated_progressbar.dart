import 'package:flutter/material.dart';

class AppAnimatedProgressbar extends StatelessWidget {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final Duration animationDuration;
  final BorderRadius? borderRadius;

  const AppAnimatedProgressbar({
    super.key,
    required this.progress,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.height = 12.0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = BorderRadius.circular(height / 2);

    return Stack(
      children: [
        // Background
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? defaultBorderRadius,
          ),
        ),
        // Animated progress
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: animationDuration,
          curve: Curves.easeInOut,
          builder: (context, animatedProgress, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: height,
                  width: constraints.maxWidth * animatedProgress,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? defaultBorderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        progressColor,
                        progressColor.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: progressColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
