import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/problem_list_progress.dart';
import 'package:codersgym/features/question/domain/repository/favorite_questions_repository.dart';

typedef ProblemListProgressState = ApiState<ProblemListProgress, Exception>;

class ProblemListProgressCubit extends Cubit<ProblemListProgressState> {
  ProblemListProgressCubit(this._favoriteQuestionsRepository)
      : super(ApiState.initial());

  Future<void> fetchProgress(String listSlug) async {
    emit(const ApiLoading());
    final result =
        await _favoriteQuestionsRepository.getProblemListProgess(listSlug);
    result.when(
      onSuccess: (value) => emit(
        ApiLoaded(value),
      ),
      onFailure: (exception) => emit(
        ApiError(exception),
      ),
    );
  }

  final FavoriteQuestionsRepository _favoriteQuestionsRepository;
}
