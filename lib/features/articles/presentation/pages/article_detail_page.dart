import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/presentation/blocs/article_comments/article_comments_bloc.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion_article_detail/discussion_article_detail_cubit.dart';
import 'package:codersgym/features/articles/presentation/widgets/article_comment_section.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class ArticleDetailPage extends HookWidget implements AutoRouteWrapper {
  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  final DiscussionArticle article;

  @override
  Widget build(BuildContext context) {
    final discussionArticleCubit = context.read<DiscussionArticleDetailCubit>();
    final commentListKey = useRef(GlobalKey());
    useEffect(() {
      discussionArticleCubit.getDiscussionArticleDetail(article);
      return null;
    }, []);
    return Scaffold(
        appBar: AppBar(
          title: Text(article.title ?? 'Post detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<DiscussionArticleDetailCubit,
              DiscussionArticleDetailState>(
            builder: (context, state) {
              return state.when(
                onInitial: () => const SizedBox.shrink(),
                onLoading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                onLoaded: (updatedArticleDetail) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: LeetcodeMarkdownWidget(
                          data: updatedArticleDetail.content ?? '',
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ArticleCommentSection(
                            key: commentListKey.value,
                            topicId: updatedArticleDetail.topicId,
                            onPageNumberChange: () {
                              if (commentListKey.value.currentContext != null) {
                                Scrollable.ensureVisible(
                                  commentListKey.value.currentContext!,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  );
                },
                onError: (exception) => Text(exception.toString()),
              );
            },
          ),
        ));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt.get<DiscussionArticleDetailCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt.get<ArticleCommentsBloc>(),
        ),
      ],
      child: this,
    );
  }
}
