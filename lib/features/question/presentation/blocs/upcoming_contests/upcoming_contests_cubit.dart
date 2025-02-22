import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UpcomingContestsCubit
    extends HydratedCubit<ApiState<List<Contest>, Exception>> {
  final QuestionRepository _questionRepository;
  UpcomingContestsCubit(this._questionRepository) : super(ApiState.initial());

  Future<void> getUpcomingContest() async {
    final result = await _questionRepository.getUpcomingContests();
   
    if (isClosed) return;
    result.when(
      onSuccess: (contests) {
        emit(ApiLoaded(contests));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }

  @override
  ApiState<List<Contest>, Exception>? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return ApiState.initial();
    }
    final contestList = (json['contestList'] as List)
        .map(
          (e) => Contest.fromJson(e),
        )
        .toList();
    return ApiLoaded(contestList);
  }

  @override
  Map<String, dynamic>? toJson(ApiState<List<Contest>, Exception> state) {
    return state.mayBeWhen(
      onLoaded: (contestList) => {
        "contestList": contestList
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      },
      orElse: () => null,
    );
  }
}
