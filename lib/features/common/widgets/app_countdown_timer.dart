import 'dart:async';
import 'package:flutter/material.dart';

class AppCountdownTimer extends StatefulWidget {
  final DateTime targetTime;
  final DateTime? referenceTime;
  final TextStyle? timeStyle;
  final TextStyle? labelStyle;
  final Color? accentColor;

  const AppCountdownTimer({
    super.key,
    required this.targetTime,
    this.referenceTime,
    this.timeStyle,
    this.labelStyle,
    this.accentColor,
  });

  @override
  State<AppCountdownTimer> createState() => _AppCountdownTimerState();
}

class _AppCountdownTimerState extends State<AppCountdownTimer>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late DateTime _initialReferenceTime;
  Duration _elapsedSinceReference = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Store the initial reference time
    _initialReferenceTime = widget.referenceTime ?? DateTime.now();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);

    // Calculate initial remaining time
    _updateRemainingTime();

    // Set up timer to update countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    if (widget.referenceTime != null) {
      // If reference time is provided, we need to simulate time passing
      // by tracking elapsed time since initialization
      _elapsedSinceReference =
          _elapsedSinceReference + const Duration(seconds: 1);

      // Calculate a simulated "current time" by adding elapsed time to the initial reference
      final simulatedNow = _initialReferenceTime.add(_elapsedSinceReference);

      if (widget.targetTime.isAfter(simulatedNow)) {
        setState(() {
          _remainingTime = widget.targetTime.difference(simulatedNow);
        });
      } else {
        setState(() {
          _remainingTime = Duration.zero;
        });
      }
    } else {
      // Normal real-time mode using current time
      final now = DateTime.now();

      if (widget.targetTime.isAfter(now)) {
        setState(() {
          _remainingTime = widget.targetTime.difference(now);
        });
      } else {
        setState(() {
          _remainingTime = Duration.zero;
        });
      }
    }
  }

  @override
  void didUpdateWidget(AppCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset the countdown if reference time or target time changes
    if (widget.referenceTime != oldWidget.referenceTime ||
        widget.targetTime != oldWidget.targetTime) {
      _initialReferenceTime = widget.referenceTime ?? DateTime.now();
      _elapsedSinceReference = Duration.zero;
      _updateRemainingTime();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default styles if not provided
    final timeStyle = widget.timeStyle ??
        theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);
    final labelStyle = widget.labelStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.hintColor,
          fontSize: 10,
        );
    final accentColor = widget.accentColor ?? theme.primaryColor;

    // Format time units with labels
    final hours = _remainingTime.inHours;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    // Only show hours if there are any
    final bool showHours = hours > 0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // Only animate when less than 10 minutes remaining
        final shouldAnimate =
            _remainingTime.inMinutes < 10 && _remainingTime.inMinutes > 0;

        return Opacity(
          opacity: shouldAnimate ? _opacityAnimation.value : 1.0,
          child: child,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHours)
            _buildTimeUnit(hours, 'h', timeStyle, labelStyle, accentColor),
          if (showHours) const SizedBox(width: 4),
          _buildTimeUnit(minutes, 'm', timeStyle, labelStyle, accentColor),
          const SizedBox(width: 4),
          _buildTimeUnit(seconds, 's', timeStyle, labelStyle, accentColor),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label, TextStyle? timeStyle,
      TextStyle? labelStyle, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: timeStyle,
          ),
          Text(
            label,
            style: labelStyle,
          ),
        ],
      ),
    );
  }
}
