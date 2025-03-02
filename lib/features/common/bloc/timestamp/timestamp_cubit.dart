import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/core/api/leetcode_api.dart';

typedef TimestampState = ApiState<double, Exception>;

class TimestampCubit extends Cubit<TimestampState> {
  TimestampCubit(this._leetcodeApi) : super(ApiState.initial());
  final LeetcodeApi _leetcodeApi;

  Future<void> getCurrentTimestamp() async {
    emit(const ApiLoading());
    try {
      final timestamp = await _leetcodeApi.getCurrentTimestamp();
      emit(ApiLoaded(timestamp?['currentTimestamp']));
    } catch (e) {
      emit(ApiError(Exception(e)));
    }
  }
}
