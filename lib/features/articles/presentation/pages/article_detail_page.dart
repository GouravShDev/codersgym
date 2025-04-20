import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/domain/model/discussion_article.dart';
import 'package:codersgym/features/articles/presentation/blocs/discussion_article_detail/discussion_article_detail_cubit.dart';
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
                onLoaded: (updatedPostDetail) {
                  return LeetcodeMarkdownWidget(
                    data: updatedPostDetail.content ?? '',
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
      ],
      child: this,
    );
  }
}
