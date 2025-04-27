import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/presentation/blocs/article_comments/article_comments_bloc.dart';
import 'package:codersgym/features/articles/presentation/widgets/article_comment_card.dart';
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
  final Function()? onPageNumberChange;

  static const int commentsPerPage =
      10; // Define this if it's not already defined elsewhere

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
      [],
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Comments',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${state.totalComments}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildCommentsList(context, state),
                if (totalPages > 1)
                  _buildPagination(context, totalPages, page, currentPage),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCommentsList(BuildContext context, ArticleCommentsState state) {
    if (state.isLoading) {
      return _buildLoadingComments();
    }

    if (state.comments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No comments yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.comments.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Divider(
          color: Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      itemBuilder: (context, index) {
        final comment = state.comments[index];
        return ArticleCommentCard(
          key: ValueKey(comment.id),
          comment: comment,
        );
      },
    );
  }

  Widget _buildLoadingComments() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return AppWidgetLoading(
          child: ArticleCommentCard.empty(),
        );
      },
    );
  }

  Widget _buildPagination(BuildContext context, int totalPages, int currentPage,
      ValueNotifier<int> pageNotifier) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPageNavButton(
            context: context,
            icon: Icons.arrow_back_ios_rounded,
            onPressed: currentPage > 1
                ? () {
                    pageNotifier.value = currentPage - 1;
                  }
                : null,
          ),
          ..._buildPageNumbers(totalPages, currentPage, pageNotifier, context),
          _buildPageNavButton(
            context: context,
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: currentPage < totalPages
                ? () => pageNotifier.value = currentPage + 1
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPageNavButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: onPressed == null
            ? Theme.of(context).disabledColor.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface.withOpacity(0.5),
        // border: Border.all(
        //   color: onPressed == null
        //       ? Theme.of(context).disabledColor.withOpacity(0.2)
        //       : Theme.of(context).dividerColor.withOpacity(0.5),
        // ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 14,
          color: onPressed == null
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.primary,
        ),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  List<Widget> _buildPageNumbers(
    int totalPages,
    int currentPage,
    ValueNotifier<int> pageNotifier,
    BuildContext context,
  ) {
    const int maxVisiblePages = 5;
    const int edgePages = 2;

    List<Widget> pageButtons = [];

    if (totalPages <= maxVisiblePages) {
      // If total pages are few, show all
      for (int i = 1; i <= totalPages; i++) {
        pageButtons
            .add(_buildPageButton(i, currentPage, pageNotifier, context));
      }
    } else {
      // Show first page
      pageButtons.add(_buildPageButton(1, currentPage, pageNotifier, context));

      // Show ellipsis or intermediate pages
      if (currentPage > 3) {
        pageButtons.add(_buildEllipsis(context));
      }

      // Show pages around current page
      int startPage = currentPage > 2 ? currentPage - 1 : 2;
      int endPage =
          currentPage < totalPages - 1 ? currentPage + 1 : totalPages - 1;

      if (startPage > 2) {
        startPage = currentPage;
      }

      if (endPage < totalPages - 1) {
        endPage = currentPage;
      }

      for (int i = startPage; i <= endPage; i++) {
        pageButtons
            .add(_buildPageButton(i, currentPage, pageNotifier, context));
      }

      // Show ellipsis if needed before last page
      if (currentPage < totalPages - 2) {
        pageButtons.add(_buildEllipsis(context));
      }

      // Show last page if not already added
      if (endPage < totalPages) {
        pageButtons.add(
            _buildPageButton(totalPages, currentPage, pageNotifier, context));
      }
    }
    return pageButtons;
  }

  Widget _buildEllipsis(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Text(
        '...',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildPageButton(
    int pageNumber,
    int currentPage,
    ValueNotifier<int> pageNotifier,
    BuildContext context,
  ) {
    final isCurrentPage = pageNumber == currentPage;

    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: isCurrentPage
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor.withOpacity(0.3),
        ),
      ),
      child: TextButton(
        onPressed: () {
          pageNotifier.value = pageNumber;
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(
            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
            color: isCurrentPage
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
