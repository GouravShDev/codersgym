import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_sliver_list.dart';
import 'package:codersgym/features/question/presentation/blocs/favorite_quesions_list/favorite_quesions_list_bloc.dart';
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
    final scrollController = useScrollController();
    final showAppBarTitle = useValueNotifier(false);

    final theme = Theme.of(context);
    useEffect(() {
      favoriteListBloc.add(FetchFavoriteQuestionsListEvent(
        favoriteSlug: sheetId,
        skip: 0,
      ));
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
                        // Sheet information
                        // Row(
                        //   children: [

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
                        ]

                        //     SizedBox(
                        //       width: 8,
                        //     ),
                        //     Column(
                        //       children: [
                        //         Container(
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 16,
                        //             vertical: 8,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color: theme.colorScheme.primaryContainer,
                        //             borderRadius: BorderRadius.circular(16),
                        //           ),
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 '${sheet.totalSolved}/${sheet.totalQuestions}',
                        //                 style:
                        //                     theme.textTheme.titleMedium?.copyWith(
                        //                   fontWeight: FontWeight.bold,
                        //                   color:
                        //                       theme.colorScheme.onPrimaryContainer,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 'Solved',
                        //                 style: theme.textTheme.bodySmall?.copyWith(
                        //                   color:
                        //                       theme.colorScheme.onPrimaryContainer,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 24),

                        // Overall progress
                        // Text(
                        //   "Your Progress",
                        //   style: theme.textTheme.titleMedium?.copyWith(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // LinearProgressIndicator(
                        //   value: sheet.totalSolved / sheet.totalQuestions,
                        //   backgroundColor: theme.colorScheme.surfaceVariant,
                        //   valueColor: AlwaysStoppedAnimation<Color>(
                        //     theme.colorScheme.primary,
                        //   ),
                        //   minHeight: 8,
                        //   borderRadius: BorderRadius.circular(4),
                        // ),
                        // const SizedBox(height: 6),
                        // Text(
                        //   "${(sheet.totalSolved / sheet.totalQuestions * 100).toStringAsFixed(1)}% Complete",
                        //   style: theme.textTheme.bodySmall,
                        // ),

                        // const SizedBox(height: 24),

                        // Difficulty-wise progress
                        // QuestionDifficultySubmissionChart(
                        //   totalEasyCount: sheet.easyTotal,
                        //   totalHardCount: sheet.hardTotal,
                        //   totalMediumCount: sheet.mediumTotal,
                        //   easyCount: sheet.easySolved,
                        //   hardCount: sheet.hardSolved,
                        //   mediumCount: sheet.mediumSolved,
                        // ),
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
      ],
      child: this,
    );
  }
}
