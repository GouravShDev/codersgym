import 'package:codersgym/features/articles/domain/model/article_comment.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:flutter/material.dart';

class ArticleCommentCard extends StatelessWidget {
  const ArticleCommentCard({
    super.key,
    required this.comment,
    required this.showReply,
    required this.onShowReplyTapped,
  });
  final ArticleComment comment;
  final bool showReply;
  final Function() onShowReplyTapped;
  @override
  Widget build(BuildContext context) {
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
                          const Icon(
                            Icons.arrow_upward,
                            size: 15,
                          ),
                          Text(
                            "${comment.voteCount}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 12),
                          ),
                          if ((comment.replyCount ?? 0) > 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  onShowReplyTapped();
                                },
                                child: const Text("Show replies"),
                              ),
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
        Column(
          children: [
            if (showReply) ...[
              _buildReplyTile(
                context,
                {
                  "id": 2956417,
                  "pinned": false,
                  "pinnedBy": null,
                  "post": {
                    "id": 9631071,
                    "voteCount": 0,
                    "content":
                        "He is from Nit, its live there are some companies who do not hire from average colleges",
                    "author": {"username": "vividvoyager22"}
                  }
                },
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildReplyTile(BuildContext context, Map<String, dynamic> reply) {
    return Padding(
      padding: const EdgeInsets.only(left: 48.0, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply["post"]["author"]["username"],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    reply["post"]["content"],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 15,
                        ),
                        Text(
                          reply["post"]["voteCount"].toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
