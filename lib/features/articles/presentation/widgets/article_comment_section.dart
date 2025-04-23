import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/presentation/blocs/article_comments/article_comments_bloc.dart';
import 'package:codersgym/features/articles/presentation/widgets/article_comment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleCommentSection extends HookWidget {
  ArticleCommentSection({
    super.key,
    required this.article,
    this.onPageNumberChange,
  });
  final DiscussionArticle article;
  final List<Map<String, dynamic>> replies = [];
  final Function()? onPageNumberChange;
  @override
  Widget build(BuildContext context) {
    final currentPage = useValueNotifier<int>(1);

    useEffect(
      () {
        context.read<ArticleCommentsBloc>().add(
              FetchArticleCommentsEvent(
                pageNo: 1,
                topicId: article.topicId ?? 0,
              ),
            );
        currentPage.addListener(
          () {
            context.read<ArticleCommentsBloc>().add(
                  FetchArticleCommentsEvent(
                    pageNo: currentPage.value,
                    topicId: article.topicId ?? 0,
                  ),
                );
          },
        );
        return null;
      },
    );
    return BlocConsumer<ArticleCommentsBloc, ArticleCommentsState>(
        // Triggers when page number is changed by user
        // checking for previous state comment because we want to prevent it to be
        // called first time (initial page 1)
        listenWhen: (previous, current) =>
            previous.pageNo != current.pageNo && previous.comments.isNotEmpty,
        listener: (context, state) {
          if (state.comments.isNotEmpty) {
            onPageNumberChange?.call();
          }
        },
        builder: (context, state) {
          final int totalPages = (state.totalComments / commentsPerPage).ceil();

          return ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, page, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments (${state.totalComments})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Builder(builder: (context) {
                        if (state.isLoading) {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return AppWidgetLoading(
                                child: ArticleCommentCard.empty(),
                              );
                            },
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.comments.length,
                          itemBuilder: (context, index) {
                            final comment = state.comments[index];
                            return ArticleCommentCard(
                              key: ValueKey(comment.id),
                              comment: comment,
                            );
                          },
                        );
                      }),
                    ),
                    if (totalPages > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            onPressed: page > 1
                                ? () {
                                    currentPage.value = page - 1;
                                  }
                                : null,
                          ),
                          ..._buildPageNumbers(totalPages, page, currentPage),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: page < totalPages
                                ? () => currentPage.value = page + 1
                                : null,
                          ),
                        ],
                      ),
                  ],
                );
              });
        });
  }

  List<Widget> _buildPageNumbers(
      int totalPages, int currentPage, ValueNotifier<int> pageNotifier) {
    const int maxVisiblePages = 5;
    const int edgePages = 2;

    List<Widget> pageButtons = [];

    if (totalPages <= maxVisiblePages) {
      // If total pages are few, show all
      for (int i = 1; i <= totalPages; i++) {
        pageButtons.add(_buildPageButton(i, currentPage, pageNotifier));
      }
    } else {
      // Show first 2 pages
      for (int i = 1; i <= edgePages; i++) {
        pageButtons.add(_buildPageButton(i, currentPage, pageNotifier));
      }

      // Show ellipsis or intermediate pages
      if (currentPage > edgePages + 1) {
        pageButtons.add(const Text('...'));
      }

      // Show current page and neighbors if not at the edges
      if (currentPage > edgePages && currentPage < totalPages - edgePages + 1) {
        pageButtons
            .add(_buildPageButton(currentPage, currentPage, pageNotifier));
      }

      // Show ellipsis if needed before last 2 pages
      if (currentPage < totalPages - edgePages) {
        pageButtons.add(const Text('...'));
      }

      // Show last page
      pageButtons.add(_buildPageButton(totalPages, currentPage, pageNotifier));
    }
    return pageButtons;
  }

  Widget _buildPageButton(
      int pageNumber, int currentPage, ValueNotifier<int> pageNotifier) {
    return TextButton(
      onPressed: () {
        pageNotifier.value = pageNumber;
      },
      child: Text(
        '$pageNumber',
        style: TextStyle(
          fontWeight:
              pageNumber == currentPage ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
