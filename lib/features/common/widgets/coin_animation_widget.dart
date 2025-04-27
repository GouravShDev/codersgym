import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/features/common/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum CoinRewardType {
  dailyCheckin,
  dailyChallenge,
  monthlyCheckin,
}

class CoinRewardAnimation extends HookWidget {
  final int? coinCount;
  final CoinRewardType type;

  const CoinRewardAnimation._({
    Key? key,
    this.coinCount,
    required this.type,
  }) : super(key: key);

  factory CoinRewardAnimation.dailyCheckin() {
    return const CoinRewardAnimation._(
      coinCount: 1,
      type: CoinRewardType.dailyCheckin,
    );
  }

  factory CoinRewardAnimation.dailyChallenge({
    required VoidCallback onComplete,
  }) {
    return const CoinRewardAnimation._(
      coinCount: 10,
      type: CoinRewardType.dailyChallenge,
    );
  }

  factory CoinRewardAnimation.monthlyCheckin({
    required VoidCallback onComplete,
  }) {
    return const CoinRewardAnimation._(
      coinCount: 30,
      type: CoinRewardType.monthlyCheckin,
    );
  }

  String _getTitle(CoinRewardType type) {
    switch (type) {
      case CoinRewardType.dailyCheckin:
        return 'Daily Checkin!';
      case CoinRewardType.dailyChallenge:
        return 'Daily Challenge Completed!';
      case CoinRewardType.monthlyCheckin:
        return 'Monthly Checkin Completed!';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = _getTitle(type);
    final count = coinCount ?? 0;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: AppNetworkImage.cached(
                      imageUrl: LeetcodeConstants.coinGif,
                      fadeInDuration: const Duration(milliseconds: 10),
                      placeholder: const CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '+$count',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
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
