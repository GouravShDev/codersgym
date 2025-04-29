import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/common/services/recent_question_manager.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';

typedef QuestionContentState = ApiState<Question, Exception>;

class QuestionContentCubit extends Cubit<ApiState<Question, Exception>> {
  QuestionContentCubit(this._questionRepository, this._recentQuestionManager)
      : super(ApiState.initial());
  final QuestionRepository _questionRepository;
  final RecentQuestionManager _recentQuestionManager;
  Future<void> getQuestionContent(Question question) async {
    if (question.titleSlug == null) {
      emit(ApiError(Exception('Question Title is null')));
      return;
    }
    emit(const ApiLoading());
    final result =
        await _questionRepository.getQuestionContent(question.titleSlug!);
    if (isClosed) {
      return;
    }
    result.when(
      onSuccess: (content) {
        _recentQuestionManager.addOrUpdateQuestion(
          RecentQuestionManager.fromFullQuestion(content),
        );
        emit(ApiLoaded(content));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
