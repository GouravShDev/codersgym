import 'dart:math';

import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/features/articles/data/entity/discussion_articles_entity.dart';
import 'package:codersgym/features/articles/domain/model/article_comment.dart';
import 'package:codersgym/features/articles/presentation/blocs/comment_replies/comment_replies_cubit.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:codersgym/core/utils/date_time_extension.dart';

class ArticleCommentCard extends HookWidget {
  const ArticleCommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
  });

  factory ArticleCommentCard.empty({bool isReply = false}) =>
      ArticleCommentCard(
        comment: ArticleComment(
          author: Author(
            userAvatar: LeetcodeConstants.defaultAvatarImg,
          ),
          voteCount: 0,
          content:
              "Loading comment text placeholder, this is just a dummy comment",
        ),
        isReply: isReply,
      );

  final ArticleComment comment;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final showReplies = useState(false);
    final displayedRepliesCount = useState(5);
    final isLoadingReplies = useState(false);

    return Container(
      margin: EdgeInsets.only(
        bottom: 8.0,
        left: isReply ? 0 : 4.0,
        right: isReply ? 0 : 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentHeader(context),
          _buildCommentContent(context),
          _buildCommentActions(context, showReplies),
          _buildRepliesSection(
            context,
            showReplies,
            displayedRepliesCount,
            isLoadingReplies,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.author?.userAvatar ?? ''),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              comment.author?.realName ?? "",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          if (comment.creationDate != null)
            Text(DateTime.fromMillisecondsSinceEpoch(
              (int.tryParse(comment.updationDate!) ?? 0) * 1000,
            ).formatDate()),
        ],
      ),
    );
  }

  Widget _buildCommentActions(
      BuildContext context, ValueNotifier<bool> showReplies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
      child: Row(
        children: [
          // Vote button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                size: 16,
              ),
              // if ((comment.voteCount ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  "${comment.voteCount}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),

          // Replies button
          if ((comment.replyCount ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextButton.icon(
                onPressed: () {
                  showReplies.value = !showReplies.value;
                },
                icon: Icon(
                  showReplies.value ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                label: Text(
                  showReplies.value
                      ? "Hide replies"
                      : "${comment.replyCount} replies",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRepliesSection(
    BuildContext context,
    ValueNotifier<bool> showReplies,
    ValueNotifier<int> displayedRepliesCount,
    ValueNotifier<bool> isLoadingReplies,
  ) {
    // Prevent infinite loop:
    // While loading, creating a new CommentReplyCubit
    // would rebuild the CommentCard, which would again create
    // a ReplyCubit, leading to recursive infinite loops.
    if (comment.id == null) {
      return const SizedBox.shrink();
    }
    return AnimatedCrossFade(
      alignment: Alignment.bottomLeft,
      firstChild: const SizedBox(height: 0),
      secondChild: BlocConsumer<CommentRepliesCubit, CommentRepliesState>(
        bloc: GetIt.I.get<CommentRepliesCubit>(
          param1: int.tryParse(comment.id ?? '0') ?? 0,
        )..fetchCommentReplies(),
        listener: (context, state) {
          state.mayBeWhen(
            onLoading: (_) => isLoadingReplies.value = true,
            onLoaded: (_) => isLoadingReplies.value = false,
            orElse: () {},
          );
        },
        builder: (context, state) {
          return state.mayBeWhen(
            onLoading: (_) => _buildLoadingReplies(),
            orElse: () => _buildLoadingReplies(),
            onLoaded: (replies) {
              if (replies.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, right: 8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: displayedRepliesCount.value > replies.length
                          ? replies.length
                          : displayedRepliesCount.value,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ArticleCommentCard(
                            key: ValueKey('reply-${replies[index].id}'),
                            comment: replies[index],
                            isReply: true,
                          ),
                        );
                      },
                    ),
                  ),
                  if (displayedRepliesCount.value < replies.length)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, bottom: 16.0, top: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          displayedRepliesCount.value =
                              displayedRepliesCount.value + 5;
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Show more replies"),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
      crossFadeState: showReplies.value
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildLoadingReplies() {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, bottom: 16.0),
      child: Column(
        children: List.generate(
          2,
          (index) => AppWidgetLoading(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ArticleCommentCard.empty(isReply: true),
            ),
          ),
        ),
      ),
    );
  }

  _buildCommentContent(BuildContext context) {
    return LeetcodeMarkdownWidget(
      data: comment.content ?? "",
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
