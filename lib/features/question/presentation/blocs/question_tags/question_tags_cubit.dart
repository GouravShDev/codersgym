import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef QuestionTagsState = ApiState<List<TopicTags>, Exception>;

class QuestionTagsCubit extends Cubit<QuestionTagsState> {
  final QuestionRepository _questionRepository;
  QuestionTagsCubit(this._questionRepository) : super(ApiState.initial());

  Future<void> getQuestionTags(Question question) async {
    if (question.titleSlug == null) {
      emit(ApiError(Exception('Question Title is null')));
      return;
    }
    emit(ApiLoading());
    final result =
        await _questionRepository.getQuestionTags(question.titleSlug!);
    if (isClosed) {
      return;
    }
    result.when(
      onSuccess: (content) {
        emit(ApiLoaded(content));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
