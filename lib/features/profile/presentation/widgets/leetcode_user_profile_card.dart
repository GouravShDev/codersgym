import 'package:codersgym/core/utils/number_extension.dart';
import 'package:codersgym/features/common/widgets/app_network_image.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_streak_fire.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../domain/model/user_profile.dart';

class LeetcodeUserProfileCard extends StatelessWidget {
  const LeetcodeUserProfileCard({
    super.key,
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppNetworkImage.avatar(
          imageUrl: userProfile.userAvatar ?? "",
          size: 80,
        ),
        // CircleAvatar(
        //   radius: 40,
        //   backgroundImage:
        //       CachedNetworkImageProvider(userProfile.userAvatar ?? ""),
        // ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProfile.realName ?? "N/A",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  userProfile.username ?? "N/A",
                  style:
                      textTheme.titleMedium?.copyWith(color: theme.hintColor),
                ),
                const SizedBox(
                  width: 8,
                ),
                Builder(builder: (context) {
                  final activeBadge = userProfile.badges?.firstWhereOrNull(
                      (badge) => badge.id == userProfile.activeBadgeId);
                  if (activeBadge == null || activeBadge.icon == null) {
                    return const SizedBox.shrink();
                  }

                  return AppNetworkImage(
                    imageUrl: activeBadge.icon!,
                    height: 20,
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Rank : ",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.outline.withOpacity(0.8),
                  ),
                ),
                Text(
                  userProfile.ranking?.toReadableNumber.toString() ?? "N/A",
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        if (userProfile.streakCounter != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                LeetCodeStreakFire(streakCounter: userProfile.streakCounter!),
          ),
      ],
    );
  }
}
