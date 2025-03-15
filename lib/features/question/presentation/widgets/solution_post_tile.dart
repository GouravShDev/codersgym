import 'package:cached_network_image/cached_network_image.dart';
import 'package:codersgym/core/utils/number_extension.dart';
import 'package:codersgym/features/common/widgets/app_network_image.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SolutionPostTile extends StatelessWidget {
  const SolutionPostTile({
    super.key,
    required this.postDetail,
    required this.onCardTap,
  });
  final CommunitySolutionPostDetail postDetail;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    final post = postDetail.post;
    final author = post?.author;
    if (post == null || author == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 1,
      child: InkWell(
        onTap: onCardTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(2),
                leading: AppNetworkImage.avatar(
                  imageUrl: author.profile?.userAvatar ?? '',
                  size: 36,
                  errorWidget: Text(
                    author.username?[0].toUpperCase() ?? '?',
                  ),
                ),
                title: Text(
                  author.username ?? 'Anonymous',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
                subtitle: Text(
                  postDetail.title ?? 'Untitled Post',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              // Tags
              if (postDetail.solutionTags != null &&
                  postDetail.solutionTags!.isNotEmpty)
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: postDetail.solutionTags!
                        .map((tag) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Chip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                    color: Theme.of(context).splashColor,
                                    width: 1.0,
                                  ),
                                ),
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    tag.name ?? '',
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInteractionItem(
                      context,
                      icon: Icons.arrow_upward,
                      count: post.voteCount ?? 0,
                    ),
                    _buildInteractionItem(
                      context,
                      icon: Icons.remove_red_eye_outlined,
                      count: postDetail.viewCount ?? 0,
                    ),
                    _buildInteractionItem(
                      context,
                      icon: Icons.comment_outlined,
                      count: postDetail.commentCount ?? 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInteractionItem(
  BuildContext context, {
  required IconData icon,
  required int count,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 18,
        color: Theme.of(context).hintColor,
      ),
      const SizedBox(width: 4),
      Text(
        count.toReadableNumber,
        style: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 12,
        ),
      ),
    ],
  );
}
