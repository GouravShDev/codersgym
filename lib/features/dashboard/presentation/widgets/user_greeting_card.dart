import 'package:cached_network_image/cached_network_image.dart';
import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/features/common/widgets/app_network_image.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:flutter/material.dart';

import '../../../profile/presentation/widgets/leetcode_streak_fire.dart';

class UserGreetingCard extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final StreakCounter? streak;
  final bool isFetching;

  const UserGreetingCard({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.streak,
    this.isFetching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (avatarUrl.isEmpty)
            ? const CircleAvatar(
                radius: 30,
                foregroundImage: CachedNetworkImageProvider(
                  LeetcodeConstants.defaultAvatarImg,
                ),
              )
            : AppNetworkImage.avatar(
                imageUrl: avatarUrl,
                size: 60,
              ),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello,',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              userName,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Additional greeting message can be added here if needed
          ],
        ),
        const Spacer(),
        if (streak != null && !isFetching)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LeetCodeStreakFire(
              streakCounter: streak!,
            ),
          ),
      ],
    );
  }

  factory UserGreetingCard.loading() {
    return const UserGreetingCard(
      userName: "Coder",
      avatarUrl: '',
      streak: null,
    );
  }
}
