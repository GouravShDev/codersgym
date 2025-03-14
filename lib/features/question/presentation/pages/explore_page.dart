import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_loading.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:codersgym/features/profile/presentation/widgets/explore_search_delegate.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/question_archieve/question_archieve_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_card.dart';
import 'package:codersgym/features/question/presentation/widgets/question_filter_bar.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class ExplorePage extends HookWidget {
  const ExplorePage({super.key});

  Widget _buildProblemTile(
    BuildContext context, {
    required Question problem,
    required Color backgroundColor,
    bool? hideDifficulty,
  }) {
    return QuestionCard(
      onTap: () {
        AutoRouter.of(context).push(
          QuestionDetailRoute(question: problem),
        );
      },
      question: problem,
      backgroundColor: backgroundColor,
      hideDifficulty: hideDifficulty,
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionArchieveBloc = context.read<QuestionArchieveBloc>();
    final theme = Theme.of(context);
    useEffect(() {
      questionArchieveBloc.add(const FetchQuestionsListEvent(skip: 0));
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Challenges"),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ExploreSearchDelegate(
                    getIt.get(),
                    getIt.get(),
                  ),
                );
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: BlocBuilder<QuestionArchieveBloc, QuestionArchieveState>(
        builder: (context, state) {
          if (state.error != null) {
            return AppErrorWidget(
              onRetry: () {
                questionArchieveBloc.add(
                  const FetchQuestionsListEvent(
                    skip: 0,
                  ),
                );
              },
            );
          }
          if (state.isLoading && state.questions.isEmpty) {
            return ListView(
              children: List.generate(
                10,
                (index) => AppWidgetLoading(child: QuestionCard.empty()),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocListener<QuestionFilterCubit, QuestionFilterState>(
                  listener: (context, state) {
                    questionArchieveBloc.add(
                      FetchQuestionsListEvent(
                        skip: 0,
                        difficulty: state.difficulty,
                        sortOption: state.sortOption,
                        topics: state.topicTags,
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 8,
                    ),
                    child: QuestionFilterBar(),
                  ),
                ),
                Expanded(
                  child: AppPaginationList(
                    onRefresh: () async {
                      final filterState =
                          context.read<QuestionFilterCubit>().state;
                      questionArchieveBloc.add(
                        FetchQuestionsListEvent(
                          skip: 0,
                          difficulty: filterState.difficulty,
                          sortOption: filterState.sortOption,
                          topics: filterState.topicTags,
                        ),
                      );
                      // To loading effect as we can't await adding events
                      await Future.delayed(Duration(seconds: 1));
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return _buildProblemTile(
                        context,
                        problem: state.questions[index],
                        backgroundColor: index % 2 == 0
                            ? theme.scaffoldBackgroundColor
                            : theme.hoverColor,
                        hideDifficulty: context
                                .read<QuestionFilterCubit>()
                                .state
                                .difficulty ==
                            null,
                      );
                    },
                    itemCount: state.questions.length,
                    loadMoreData: () {
                      final filterState =
                          context.read<QuestionFilterCubit>().state;
                      questionArchieveBloc.add(
                        FetchQuestionsListEvent(
                          difficulty: filterState.difficulty,
                          sortOption: filterState.sortOption,
                          topics: filterState.topicTags,
                        ),
                      );
                    },
                    moreAvailable: state.moreQuestionAvailable,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
