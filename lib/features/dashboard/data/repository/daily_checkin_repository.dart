import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/error/result.dart';
import 'package:codersgym/core/error/exception.dart';
import 'package:codersgym/features/dashboard/domain/repository/daily_checkin_repository.dart';

class DailyCheckinRepositoryImp implements DailyCheckinRepository {
  final LeetcodeApi _leetcodeApi;

  DailyCheckinRepositoryImp(this._leetcodeApi);

  @override
  Future<Result<bool, Exception>> dailyCheckin() async {
    try {
      final response = await _leetcodeApi.dailyCheckin();
      if (response == null || response['checkin'] == null) {
        return Failure(Exception("Failed to checkin"));
      }

      return Success(
        response['checkin']['checkedIn'],
      );
    } on ApiException catch (e) {
      return Failure(Exception(e.message));
    }
  }
}
