import 'package:bloc/bloc.dart';
import 'package:codersgym/features/question/data/entity/community_solution_sort_option.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/community_solution_repository.dart';
import 'package:equatable/equatable.dart';

part 'community_solution_filter_state.dart';

class CommunitySolutionFilterCubit extends Cubit<CommunitySolutionFilterState> {
  final CommunitySolutionRepository _communitySolutionRepository;
  CommunitySolutionFilterCubit(this._communitySolutionRepository)
      : super(CommunitySolutionFilterState.initial());

  Future<void> fetchSolutionsTags(Question question) async {
    final result = await _communitySolutionRepository
        .getSolutionTags(question.titleSlug ?? '');

    if (isClosed) return;
    result.when(
      onSuccess: (value) {
        final (:languageTags, :topicTags) = value;

        emit(
          state.copyWith(
            isTagsLoading: false,
            availableLanguageTags: languageTags,
            availableTopicTags: topicTags,
          ),
        );
      },
      onFailure: (exception) {
        emit(
          state.copyWith(error: exception),
        );
      },
    );
  }

  void updateFilters({
    required Set<SolutionTag> topicTags,
    required Set<SolutionTag> languageTags,
    required String searchQuery,
    required CommunitySolutionSortOption sortOption,
  }) {
    emit(
      state.copyWith(
        searchQuery: searchQuery,
        sortOption: sortOption,
        selectedLanguageTags: languageTags.toList(),
        selectedTopicTags: topicTags.toList(),
      ),
    );
  }
}
