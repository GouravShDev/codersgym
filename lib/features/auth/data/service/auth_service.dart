import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/auth/data/entity/user_status_entity.dart';
import 'package:codersgym/features/auth/domain/service/auth_service.dart';
import 'package:codersgym/features/common/services/recent_question_manager.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthServiceImp implements AuthService {
  final StorageManager _storageManager;
  final LeetcodeApi _leetcodeApi;
  final HydratedStorage _blocCaching;
  final RecentQuestionManager _recentQuestionManager;

  AuthServiceImp(
    this._storageManager,
    this._leetcodeApi,
    this._blocCaching,
    this._recentQuestionManager,
  );
  @override
  Future<AuthenticationStatus> checkAuthentication() async {
    try {
      final credentials =
          await _storageManager.getObjectMap(_storageManager.leetcodeSession);
      final leetcodeUserName =
          await _storageManager.getString(_storageManager.leetcodeUserName);
      if (leetcodeUserName == null) {
        return UnAuthenticatedStatus();
      }
      bool shouldRenewCredentials = false;
      if (credentials != null) {
        if (credentials['expiry'] is int) {
          int timestamp = credentials['expiry'];
          // Convert milliseconds to DateTime and adjust to local time
          DateTime expiryDate =
              DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
          DateTime currentDateTime = DateTime.now();

          // Check if credentials have expired
          shouldRenewCredentials = currentDateTime.isAfter(expiryDate);
        }
        return LeetcodeAccountAuthenticated(
          credentials: credentials,
          userName: leetcodeUserName,
          shouldRenewCredentials: shouldRenewCredentials,
        );
      }
      return LeetcodeUsernameAuthenticated(userName: leetcodeUserName);
    } catch (e) {
      return UnAuthenticatedStatus();
    }
  }

  @override
  Future<AuthenticationStatus> loginWithLeetcodeAccount(
    Map<String, dynamic> credentials,
  ) async {
    await _storageManager.putObjectMp(
      _storageManager.leetcodeSession,
      credentials,
    );
    final data = await _leetcodeApi.getGlobalData();
    if (data == null) {
      await logout();
      return UnAuthenticatedStatus();
    }
    final userEntity = UserStatusEntity.fromJson(data['userStatus']);
    final userName = userEntity.username;
    await _storageManager.putString(_storageManager.leetcodeUserName, userName);

    return LeetcodeAccountAuthenticated(
      credentials: credentials,
      userName: userName,
      shouldRenewCredentials: false,
    );
  }

  @override
  Future<AuthenticationStatus> loginWithLeetcodeUserName(
      String userName) async {
    await _storageManager.putString(_storageManager.leetcodeUserName, userName);
    return LeetcodeUsernameAuthenticated(userName: userName);
  }

  @override
  Future<AuthenticationStatus> logout() async {
    await _storageManager.clearKey(_storageManager.leetcodeSession);
    await _storageManager.clearKey(_storageManager.leetcodeUserName);
    CookieManager.instance().deleteAllCookies();
    _blocCaching.clear();
    _recentQuestionManager.clearRecentQuestions();
    return UnAuthenticatedStatus();
  }
}

extension AuthServiceStorageExtension on StorageManager {
  String get leetcodeSession => 'leetcode_session';
  String get leetcodeUserName => 'leetcode_username';
}
