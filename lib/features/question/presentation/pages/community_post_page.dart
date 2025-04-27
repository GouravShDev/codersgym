import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/articles/presentation/blocs/article_comments/article_comments_bloc.dart';
import 'package:codersgym/features/articles/presentation/widgets/article_comment_section.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class CommunityPostPage extends HookWidget implements AutoRouteWrapper {
  const CommunityPostPage({
    super.key,
    required this.postDetail,
  });

  final CommunitySolutionPostDetail postDetail;

  @override
  Widget build(BuildContext context) {
    final communityPostCubit = context.read<CommunityPostDetailCubit>();
    useEffect(() {
      communityPostCubit.getCommunitySolutionsDetails(postDetail);
      return null;
    }, []);
    final commentListKey = useRef(GlobalKey());

    return Scaffold(
        appBar: AppBar(
          title: Text(postDetail.title ?? 'Post detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              BlocBuilder<CommunityPostDetailCubit, CommunityPostDetailState>(
            builder: (context, state) {
              return state.when(
                onInitial: () => const SizedBox.shrink(),
                onLoading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                onLoaded: (updatedPostDetail) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: LeetcodeMarkdownWidget(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          data: updatedPostDetail.post?.content ?? '',
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: BlocProvider(
                            create: (context) =>
                                GetIt.I.get<ArticleCommentsBloc>(),
                            child: ArticleCommentSection(
                              key: commentListKey.value,
                              topicId: updatedPostDetail.id,
                              onPageNumberChange: () {
                                if (commentListKey.value.currentContext !=
                                    null) {
                                  Scrollable.ensureVisible(
                                    commentListKey.value.currentContext!,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
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
          create: (_) => getIt.get<CommunityPostDetailCubit>(),
        ),
      ],
      child: this,
    );
  }
}
