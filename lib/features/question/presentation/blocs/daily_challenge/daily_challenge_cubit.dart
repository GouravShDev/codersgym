import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class DailyChallengeCubit extends HydratedCubit<ApiState<Question, Exception>> {
  DailyChallengeCubit(this._questionRepository)
      : super(ApiState<Question, Exception>.initial());
  final QuestionRepository _questionRepository;
  Future<void> getTodayChallenge() async {
    final result = await _questionRepository.getTodayChallenge();
   
    if (isClosed) return;
    result.when(
      onSuccess: (value) {
        emit(ApiLoaded(value));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }

  @override
  ApiState<Question, Exception>? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return ApiState.initial();
    }
    return ApiLoading(cachedData: Question.fromJson(json));
  }

  @override
  Map<String, dynamic>? toJson(ApiState<Question, Exception> state) {
    return state.mayBeWhen(
      orElse: () => null,
      onLoaded: (value) => value.toJson(),
    );
  }
}
