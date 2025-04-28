import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AppAnimatedTextWidget extends StatelessWidget {
  final List<String> texts;
  final TextStyle? textStyle;
  final Duration speed;
  final AnimatedTextType animationType;
  final bool repeatForever;
  final int repeatCount;

  const AppAnimatedTextWidget({
    super.key,
    required this.texts,
    this.textStyle,
    this.speed = const Duration(milliseconds: 100),
    this.animationType = AnimatedTextType.typer,
    this.repeatForever = true,
    this.repeatCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: _buildAnimatedTexts(),
      repeatForever: repeatForever,
      totalRepeatCount: repeatForever ? 0 : repeatCount,
      isRepeatingAnimation: true,
      pause: const Duration(milliseconds: 500),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }

  List<AnimatedText> _buildAnimatedTexts() {
    switch (animationType) {
      case AnimatedTextType.fade:
        return texts
            .map((text) => FadeAnimatedText(
                  text,
                  textStyle: textStyle,
                  duration: speed,
                  fadeOutBegin: 0.8,
                  fadeInEnd: 0.2,
                ))
            .toList();
      case AnimatedTextType.typewriter:
        return texts
            .map((text) => TypewriterAnimatedText(
                  text,
                  textStyle: textStyle,
                  speed: speed,
                ))
            .toList();
      case AnimatedTextType.scale:
        return texts
            .map((text) => ScaleAnimatedText(
                  text,
                  textStyle: textStyle,
                  duration: speed,
                ))
            .toList();
      case AnimatedTextType.wavy:
        return texts
            .map((text) => WavyAnimatedText(
                  text,
                  textStyle: textStyle,
                ))
            .toList();
      case AnimatedTextType.typer:
        return texts
            .map((text) => TyperAnimatedText(
                  text,
                  textStyle: textStyle,
                  speed: speed,
                ))
            .toList();
    }
  }
}

enum AnimatedTextType {
  typer,
  typewriter,
  fade,
  scale,
  wavy,
}
