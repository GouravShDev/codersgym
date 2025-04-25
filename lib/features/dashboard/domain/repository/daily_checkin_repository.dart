import 'package:codersgym/core/error/result.dart';

abstract interface class DailyCheckinRepository {
  Future<Result<bool, Exception>> dailyCheckin();
}