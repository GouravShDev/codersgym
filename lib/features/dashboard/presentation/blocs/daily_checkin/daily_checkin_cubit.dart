import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/dashboard/domain/repository/daily_checkin_repository.dart';

typedef DailyCheckinState = ApiState<bool, Exception>;

class DailyCheckinCubit extends Cubit<DailyCheckinState> {
  DailyCheckinCubit(this._dailyCheckinRepository) : super(ApiInitial());

  final DailyCheckinRepository _dailyCheckinRepository;

  Future<void> checkIn() async {
    emit(const ApiLoading());
    final result = await _dailyCheckinRepository.dailyCheckin();
    if (isClosed) {
      return;
    }
    result.when(
      onSuccess: (dailyCheckIn) {
        emit(ApiLoaded(dailyCheckIn));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
