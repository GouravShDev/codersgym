import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:codersgym/features/question/presentation/blocs/question_archieve/question_archieve_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/question_filter/question_filter_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/question_card.dart';
import 'package:codersgym/features/question/presentation/widgets/question_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_router.gr.dart';

class ExploreSearchDelegate extends SearchDelegate<String> {
  final QuestionArchieveBloc _questionArchieveBloc;
  final QuestionFilterCubit _questionFilterCubit;
  ExploreSearchDelegate(
    this._questionArchieveBloc,
    this._questionFilterCubit,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(query),
            const Spacer(),
            Center(
              child: Text(
                "Search questions",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    }
    _questionArchieveBloc.add(
      FetchQuestionsListEvent(
        searchKeyword: query,
        skip: 0,
        difficulty: _questionFilterCubit.state.difficulty,
        sortOption: _questionFilterCubit.state.sortOption,
        topics: _questionFilterCubit.state.topicTags,
      ),
    );
    return BlocBuilder<QuestionArchieveBloc, QuestionArchieveState>(
      bloc: _questionArchieveBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(query),
              if (state.questions.isNotEmpty)
                Expanded(
                  child: AppPaginationList(
                    itemBuilder: (BuildContext context, int index) {
                      return QuestionCard(
                        question: state.questions[index],
                        hideDifficulty:
                            _questionFilterCubit.state.difficulty == null,
                        onTap: () {
                          AutoRouter.of(context).push(
                            QuestionDetailRoute(
                                question: state.questions[index]),
                          );
                        },
                      );
                    },
                    itemCount: state.questions.length,
                    loadMoreData: () {
                      _questionArchieveBloc.add(
                        FetchQuestionsListEvent(
                          searchKeyword: query,
                          difficulty: _questionFilterCubit.state.difficulty,
                          sortOption: _questionFilterCubit.state.sortOption,
                          topics: _questionFilterCubit.state.topicTags,
                        ),
                      );
                    },
                    moreAvailable: state.moreQuestionAvailable,
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Text(
                      "Looks like we couldn't find a match.\nTry modifying filters!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters(String query) {
    return BlocProvider<QuestionFilterCubit>.value(
      value: _questionFilterCubit,
      child: BlocListener<QuestionFilterCubit, QuestionFilterState>(
        listener: (context, state) {
          _questionArchieveBloc.add(
            FetchQuestionsListEvent(
              skip: 0,
              searchKeyword: query,
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
    );
  }
}
