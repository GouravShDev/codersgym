import 'package:bloc/bloc.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_quesions_list_event.dart';
part 'favorite_quesions_list_state.dart';

class FavoriteQuesionsListBloc
    extends Bloc<FavoriteQuesionsListEvent, FavoriteQuesionsListState> {
  int currentSkip = 0;
  int currentLimit = 10;
  FavoriteQuesionsListBloc(this.favoriteQuestiionsRepository)
      : super(FavoriteQuesionsListState.initial()) {
    on<FetchFavoriteQuestionsListEvent>(
        (event, emit) => _onFetchFavoriteQuestionList(event, emit));
  }

  Future<void> _onFetchFavoriteQuestionList(
    FetchFavoriteQuestionsListEvent event,
    Emitter<FavoriteQuesionsListState> emit,
  ) async {
    // Prevent unnecessary api calls
    if (event.skip != 0 &&
        state.questions.isNotEmpty &&
        !state.moreQuestionAvailable) {
      return;
    }

    // Set values to input if provided
    currentLimit = event.limit ?? currentLimit;
    currentSkip = event.skip ?? currentSkip;
    if (state.isLoading) {
      return; // Prevent mutliple call resulting in duplicate items
    }
    emit(
      state.copyWith(
        isLoading: true,
      ),
    );
    final result = await favoriteQuestiionsRepository.getFavoriteQuesitions(
      FavoriteQuestionQueryInput(
        skip: currentSkip,
        limit: currentLimit,
        favoriteSlug: event.favoriteSlug,
        sortOption: event.sortOption,
      ),
    );

    if (isClosed) return;
    result.when(
      onSuccess: (newQuestionList) {
        List<Question> currentQuestionList =
            List<Question>.from(state.questions);
        // resent list if the skip is zero in the event
        if (event.skip == 0) {
          currentQuestionList.clear();
        }
        final updatedList = currentQuestionList
          ..addAll(
            newQuestionList.$1,
          );
        final moreQuestionAvailable = updatedList.length < newQuestionList.$2;
        // Update currentSkip
        currentSkip = updatedList.length;

        emit(
          state.copyWith(
            questions: updatedList,
            moreQuestionAvailable: moreQuestionAvailable,
            isLoading: false,
          ),
        );
      },
      onFailure: (exception) {
        emit(
          state.copyWith(
            error: exception,
            isLoading: false,
          ),
        );
      },
    );
    // result
  }

  final FavoriteQuestionsRepository favoriteQuestiionsRepository;
}
