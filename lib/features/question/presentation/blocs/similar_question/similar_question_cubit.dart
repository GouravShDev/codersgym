import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef SimilarQuestionState = ApiState<List<Question>, Exception>;

class SimilarQuestionCubit extends Cubit<SimilarQuestionState> {
  final QuestionRepository _questionRepository;
  SimilarQuestionCubit(this._questionRepository) : super(ApiState.initial());

  Future<void> getSimilarQuestions(Question question) async {
    emit(ApiLoading());
    final result = await _questionRepository.getSimilarQuestions(
      question.titleSlug ?? '',
    );
    if (isClosed) {
      return;
    }
    result.when(
      onSuccess: (questionList) {
        emit(ApiLoaded(questionList));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
