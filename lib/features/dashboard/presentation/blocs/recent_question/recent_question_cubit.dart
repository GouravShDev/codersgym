import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/common/data/models/recent_question.dart';
import 'package:codersgym/features/common/services/recent_question_manager.dart';
import 'package:codersgym/features/question/domain/model/question.dart';

typedef RecentQuestionState = ApiState<List<Question>, Exception>;

class RecentQuestionCubit extends Cubit<RecentQuestionState> {
  RecentQuestionCubit(this._recentQuestionManager) : super(ApiState.initial());

  final RecentQuestionManager _recentQuestionManager;

  Future<void> getRecentQuestions() async {
    emit(const ApiLoading());
    final result = await _recentQuestionManager.getRecentQuestions();
    result.when(
      onSuccess: (questions) {
        emit(
          ApiLoaded(
            questions
                .map(
                  (e) => e.toQuestion(),
                )
                .toList(),
          ),
        );
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}

extension RecentQuestionExtension on RecentQuestion {
  Question toQuestion() {
    return Question(
      title: title,
      titleSlug: titleSlug,
      difficulty: difficulty,
      acRate: acRate,
      frontendQuestionId: frontendQuestionId,
      status: status,
    );
  }
}
