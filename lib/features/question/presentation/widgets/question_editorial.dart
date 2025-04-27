import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/articles/presentation/blocs/article_comments/article_comments_bloc.dart';
import 'package:codersgym/features/articles/presentation/widgets/article_comment_section.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_solution/question_solution_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

class QuestionEditorial extends HookWidget {
  const QuestionEditorial({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  Widget build(BuildContext context) {
    final questionSolutionCubit = context.read<QuestionSolutionCubit>();
    final commentListKey = useRef(GlobalKey());
    useEffect(() {
      questionSolutionCubit.getQuestionSolution(question.titleSlug ?? '');
      return null;
    }, []);

    return BlocBuilder<QuestionSolutionCubit, QuestionSolutionState>(
      builder: (context, state) {
        return state.when(
          onInitial: () => const CircularProgressIndicator(),
          onLoading: (_) => const CircularProgressIndicator(),
          onLoaded: (solution) {
            return CustomScrollView(
              controller: InheritedDataProvider.of<ScrollController>(context),
              slivers: [
                SliverToBoxAdapter(
                  child: LeetcodeMarkdownWidget(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    assetsBaseUrl:
                        "${LeetcodeConstants.leetcodeUrl}/problems/${question.titleSlug}",
                    data: solution.content ?? '',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: BlocProvider(
                      create: (context) => GetIt.I.get<ArticleCommentsBloc>(),
                      child: ArticleCommentSection(
                        key: commentListKey.value,
                        topicId: solution.topicId,
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
                  ),
                ),
              ],
            );
          },
          onError: (exception) => const AppErrorWidget(
            message: "Solution Not Available",
            showRetryButton: false,
          ),
        );
      },
    );
  }
}
