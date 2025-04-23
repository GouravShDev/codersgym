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
import 'package:uuid/uuid.dart';

class ArticleCommentCard extends HookWidget {
  const ArticleCommentCard({
    super.key,
    required this.comment,
  });

  factory ArticleCommentCard.empty() => ArticleCommentCard(
        comment: ArticleComment(
          id: const Uuid().v4(),
          author: Author(
            userAvatar: LeetcodeConstants.defaultAvatarImg,
          ),
          voteCount: 0,
          content:
              "Loading comment text placeholder, this is just a dummy comment",
        ),
      );

  final ArticleComment comment;
  @override
  Widget build(BuildContext context) {
    final showReply = useValueNotifier(false);
    final displayedRepliesCount = useState(5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.author?.userAvatar ?? ''),
                radius: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.author?.realName ?? "",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    LeetcodeMarkdownWidget(
                      data: comment.content ?? "",
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_upward_rounded,
                                size: 18,
                              ),
                              if ((comment.voteCount ?? 0) > 0)
                                const SizedBox(width: 4.0),
                              if ((comment.voteCount ?? 0) > 0)
                                Text(
                                  "${comment.voteCount}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              if ((comment.replyCount ?? 0) > 0)
                                ValueListenableBuilder(
                                    valueListenable: showReply,
                                    builder: (context, _, __) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextButton(
                                          onPressed: () {
                                            showReply.value = !showReply.value;
                                          },
                                          child: Text(showReply.value
                                              ? "Hide replies"
                                              : "Show ${comment.replyCount} replies"),
                                        ),
                                      );
                                    }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
            valueListenable: showReply,
            builder: (context, _, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  );
                },
                child: !showReply.value
                    ? const SizedBox.shrink(key: ValueKey("shrink"))
                    : BlocBuilder<CommentRepliesCubit, CommentRepliesState>(
                        key: const ValueKey("comment-replies"),
                        bloc: GetIt.I.get<CommentRepliesCubit>(
                          param1: int.tryParse(comment.id ?? '') ?? '',
                        )..fetchCommentReplies(),
                        builder: (context, state) {
                          return state.mayBeWhen(
                            orElse: () => AppWidgetLoading(
                                child: Column(
                                    children: List.generate(
                              3,
                              (index) => ArticleCommentCard.empty(),
                            ))),
                            onLoaded: (replies) {
                              return Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: displayedRepliesCount.value >
                                            replies.length
                                        ? replies.length
                                        : displayedRepliesCount.value,
                                    itemBuilder: (context, index) =>
                                        _buildReplyTile(
                                      context,
                                      replies[index],
                                    ),
                                  ),
                                  if (displayedRepliesCount.value <
                                      replies.length)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        onPressed: () {
                                          displayedRepliesCount.value =
                                              displayedRepliesCount.value + 5;
                                        },
                                        child: Text(
                                          "Show more",
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        }),
              );
            }),
      ],
    );
  }

  Widget _buildReplyTile(BuildContext context, ArticleComment reply) {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: Card(child: ArticleCommentCard(comment: reply)),
          ),
        ],
      ),
    );
  }
}
