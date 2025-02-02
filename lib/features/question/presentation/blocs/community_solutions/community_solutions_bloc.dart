import 'package:bloc/bloc.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'community_solutions_event.dart';
part 'community_solutions_state.dart';

class CommunitySolutionsBloc
    extends Bloc<CommunitySolutionsEvent, CommunitySolutionsState> {
  final QuestionRepository _questionRepository;

  int currentSkip = 0;
  int currentLimit = 10;
  CommunitySolutionsBloc(
    this._questionRepository,
  ) : super(CommunitySolutionsState.initial()) {
    on<CommunitySolutionsEvent>(
      (event, emit) async {
        switch (event) {
          case FetchCommunitySolutionListEvent():
            await _onFetchSolutionList(event, emit);
            break;
          default:
            break;
        }
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .asyncExpand(mapper),
    );
  }

  Future<void> _onFetchSolutionList(FetchCommunitySolutionListEvent event,
      Emitter<CommunitySolutionsState> emit) async {
// resent list if the skip is zero in the event
    if (event.skip == 0) {
      emit(state.copyWith(questions: []));
    }
    // Prevent unnecessary api calls
    if (state.solutions.isNotEmpty && !state.moreSolutionsAvailable) {
      return;
    }

    // Set values to input if provided
    currentLimit = event.limit ?? currentLimit;
    currentSkip = event.skip ?? currentSkip;
    if (state.isLoading) {
      return; // Prevent mutliple call resulting in duplicate items
    }
    emit(state.copyWith(isLoading: true));
    final result = await _questionRepository.getCommunitySolutions(
      CommunitySolutionsInput(
        skip: currentSkip,
        limit: currentLimit,
        questiontitleSlug: event.questionTitleSlug ?? '',
        orderBy:
            'hot', // Temporary passing "hot" as default until filter are implemented
      ),
    );

    result.when(
      onSuccess: (newSolutionListWithSolutionCount) {
        final updatedList =
            List<CommunitySolutionPostDetail>.from(state.solutions)
              ..addAll(
                newSolutionListWithSolutionCount.solutionList,
              );
        final moreSolutionAvailable = updatedList.length <
            newSolutionListWithSolutionCount.totalSolutionCount;
        // Update currentSkip
        currentSkip = updatedList.length;

        emit(
          state.copyWith(
            questions: updatedList,
            isLoading: false,
            moreQuestionAvailable: moreSolutionAvailable,
          ),
        );
      },
      onFailure: (exception) {
        emit(
          state.copyWith(error: exception, isLoading: false),
        );
      },
    );
  }
}
