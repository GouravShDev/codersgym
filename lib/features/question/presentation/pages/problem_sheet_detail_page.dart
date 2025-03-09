import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_sliver_list.dart';
import 'package:codersgym/features/profile/presentation/widgets/question_difficulty_legend.dart';
import 'package:codersgym/features/question/presentation/blocs/favorite_quesions_list/favorite_quesions_list_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/problem_list_progress/problem_list_progress_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_card.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class ProblemSheetDetailPage extends HookWidget implements AutoRouteWrapper {
  final String sheetId;
  final String sheetName;
  final String? sheetDescription;
  final String? sheetAuthor;

  const ProblemSheetDetailPage({
    super.key,
    required this.sheetId,
    required this.sheetName,
    this.sheetAuthor,
    this.sheetDescription,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteListBloc = context.read<FavoriteQuesionsListBloc>();
    final problemProgressCubit = context.read<ProblemListProgressCubit>();
    final scrollController = useScrollController();
    final showAppBarTitle = useValueNotifier(false);

    final theme = Theme.of(context);
    useEffect(() {
      favoriteListBloc.add(FetchFavoriteQuestionsListEvent(
        favoriteSlug: sheetId,
        skip: 0,
      ));
      problemProgressCubit.fetchProgress(sheetId);
      final titleFontSize = theme.textTheme.titleLarge?.fontSize ?? 12;
      final pixelAfterTitleHide = titleFontSize + 10;
      scrollController.addListener(
        () {
          if (scrollController.position.pixels > pixelAfterTitleHide) {
            showAppBarTitle.value = true;
          } else {
            showAppBarTitle.value = false;
          }
        },
      );

      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: showAppBarTitle,
          builder: (context, value, _) {
            return Text(value ? sheetName : "");
          },
        ),
      ),
      body: BlocBuilder<FavoriteQuesionsListBloc, FavoriteQuesionsListState>(
        builder: (context, state) {
          if (state.error != null) {
            return AppErrorWidget(
              onRetry: () {
                favoriteListBloc.add(
                  FetchFavoriteQuestionsListEvent(
                    favoriteSlug: sheetId,
                    skip: 0,
                  ),
                );
              },
            );
          }
          if (state.isLoading && state.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.questions.isEmpty) {
            return const Center(child: Text("No Questions available"));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sheetName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (sheetAuthor != null)
                              Text(
                                sheetAuthor!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              )
                          ],
                        ),
                        if (sheetDescription != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            sheetDescription!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                        BlocBuilder<ProblemListProgressCubit,
                            ProblemListProgressState>(
                          builder: (context, state) {
                            return state.mayBeWhen(
                              onLoaded: (sheetProgress) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: QuestionDifficultyLegend(
                                    totalEasyCount: sheetProgress.totalEasy,
                                    totalHardCount: sheetProgress.totalHard,
                                    totalMediumCount: sheetProgress.totalMedium,
                                    easyCount: sheetProgress.solvedEasy,
                                    hardCount: sheetProgress.solvedHard,
                                    mediumCount: sheetProgress.solvedMedium,
                                    isHorizontal: true,
                                  ),
                                );
                              },
                              orElse: () => SizedBox.shrink(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                AppPaginationSliverList(
                  // onRefresh: () async {
                  //   favoriteListBloc.add(
                  //     FetchFavoriteQuestionsListEvent(
                  //       skip: 0,
                  //       favoriteSlug: sheetId,
                  //     ),
                  //   );
                  //   // To loading effect as we can't await adding events
                  //   await Future.delayed(const Duration(seconds: 1));
                  // },
                  itemBuilder: (BuildContext context, int index) {
                    return QuestionCard(
                      question: state.questions[index],
                      backgroundColor: index % 2 == 0
                          ? theme.scaffoldBackgroundColor
                          : theme.hoverColor,
                      onTap: () {
                        AutoRouter.of(context).push(
                          QuestionDetailRoute(question: state.questions[index]),
                        );
                      },
                    );
                  },
                  itemCount: state.questions.length,
                  loadMoreData: () {
                    favoriteListBloc.add(
                      FetchFavoriteQuestionsListEvent(
                        favoriteSlug: sheetId,
                      ),
                    );
                  },
                  moreAvailable: state.moreQuestionAvailable,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<FavoriteQuesionsListBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt.get<ProblemListProgressCubit>(),
        ),
      ],
      child: this,
    );
  }
}
