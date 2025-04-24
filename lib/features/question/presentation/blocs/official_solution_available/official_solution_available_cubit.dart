import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef OfficialSolutionAvailableState = ApiState<bool, Exception>;

class OfficialSolutionAvailableCubit
    extends Cubit<OfficialSolutionAvailableState> {
  final QuestionRepository _questionRepository;
  OfficialSolutionAvailableCubit(this._questionRepository)
      : super(ApiState.initial());

  Future<void> checkOfficialSolutionAvailable(Question question) async {
    if (question.titleSlug == null) {
      emit(ApiError(Exception('Question Title is null')));
      return;
    }
    emit(const ApiLoading());
    final result =
        await _questionRepository.hasOfficialSolution(question.titleSlug!);
    if (isClosed) {
      return;
    }
    result.when(
      onSuccess: (isAvailable) {
        emit(ApiLoaded(isAvailable));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
