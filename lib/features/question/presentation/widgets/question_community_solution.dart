import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solution_filter/community_solution_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solutions/community_solutions_bloc.dart';
import 'package:codersgym/features/question/presentation/widgets/no_solution_state_widget.dart';
import 'package:codersgym/features/question/presentation/widgets/solution_filter_search_bar.dart';
import 'package:codersgym/features/question/presentation/widgets/solution_post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestionCommunitySolution extends HookWidget {
  const QuestionCommunitySolution({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    final communitySolutionCubit = context.read<CommunitySolutionsBloc>();
    final communityFilterCubit = context.read<CommunitySolutionFilterCubit>();

    useEffect(
      () {
        communityFilterCubit.fetchSolutionsTags(question);
        communitySolutionCubit.add(
          FetchCommunitySolutionListEvent(
            questionTitleSlug: question.titleSlug ?? '',
            orderBy: communityFilterCubit.state.sortOption,
            searchQuery: communityFilterCubit.state.searchQuery,
            languageTags: communityFilterCubit.state.selectedLanguageTags,
            topicTags: communityFilterCubit.state.selectedTopicTags,
            skip: 0,
          ),
        );
        return null;
      },
      [],
    );
    return BlocListener<CommunitySolutionFilterCubit,
        CommunitySolutionFilterState>(
      listener: (context, state) {
        communitySolutionCubit.add(
          FetchCommunitySolutionListEvent(
            questionTitleSlug: question.titleSlug ?? '',
            orderBy: state.sortOption,
            searchQuery: state.searchQuery,
            languageTags: state.selectedLanguageTags,
            topicTags: state.selectedTopicTags,
            skip: 0,
          ),
        );
      },
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          // Filter widget with padding
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceInOut,
            alignment: Alignment.topCenter,
            child: BlocBuilder<CommunitySolutionFilterCubit,
                CommunitySolutionFilterState>(
              builder: (context, state) {
                if (state.isTagsLoading) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4)
                      .add(const EdgeInsets.only(
                    top: 4,
                  )),
                  child: SolutionFilterSearchBar(
                    initialSearchQuery: state.searchQuery,
                    initialSortOption: state.sortOption,
                    initialKnowledgeTags: state.selectedTopicTags.toSet(),
                    initialLanguageTags: state.selectedLanguageTags.toSet(),
                    availableKnowledgeTags: state.availableTopicTags.toSet(),
                    availableLanguageTags: state.availableLanguageTags.toSet(),
                    onFiltersChanged: ({
                      required languageTags,
                      required searchQuery,
                      required sortOption,
                      required topicTags,
                    }) {
                      communityFilterCubit.updateFilters(
                        languageTags: languageTags,
                        searchQuery: searchQuery,
                        sortOption: sortOption,
                        topicTags: topicTags,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          BlocBuilder<CommunitySolutionsBloc, CommunitySolutionsState>(
            builder: (context, state) {
              final solutions = state.solutions;
              if (state.isLoading && solutions.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.error != null) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppErrorWidget(
                    onRetry: () {
                      communityFilterCubit.fetchSolutionsTags(question);
                      communitySolutionCubit.add(
                        FetchCommunitySolutionListEvent(
                          questionTitleSlug: question.titleSlug ?? '',
                          orderBy: communityFilterCubit.state.sortOption,
                          searchQuery: communityFilterCubit.state.searchQuery,
                          languageTags:
                              communityFilterCubit.state.selectedLanguageTags,
                          topicTags:
                              communityFilterCubit.state.selectedTopicTags,
                          skip: 0,
                        ),
                      );
                    },
                  ),
                );
              }
              if (solutions.isEmpty && !state.moreSolutionsAvailable) {
                return const Expanded(
                  child: Center(
                    child: NoSolutionStateWidget(),
                  ),
                );
              }
              return Expanded(
                child: AppPaginationList(
                  scrollController:
                      InheritedDataProvider.of<ScrollController>(context),
                  itemBuilder: (context, index) {
                    return SolutionPostTile(
                      postDetail: solutions[index],
                      onCardTap: () {
                        AutoRouter.of(context).push(
                          CommunityPostRoute(
                            postDetail: solutions[index],
                          ),
                        );
                      },
                    );
                  },
                  itemCount: solutions.length,
                  moreAvailable: state.moreSolutionsAvailable,
                  loadMoreData: () {
                    communitySolutionCubit.add(
                      FetchCommunitySolutionListEvent(
                        questionTitleSlug: question.titleSlug ?? '',
                        orderBy: communityFilterCubit.state.sortOption,
                        searchQuery: communityFilterCubit.state.searchQuery,
                        languageTags:
                            communityFilterCubit.state.selectedLanguageTags,
                        topicTags: communityFilterCubit.state.selectedTopicTags,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
