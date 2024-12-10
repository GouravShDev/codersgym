import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/auth/data/entity/user_status_entity.dart';
import 'package:codersgym/features/auth/domain/service/auth_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AuthServiceImp implements AuthService {
  final StorageManager _storageManager;
  final LeetcodeApi _leetcodeApi;

  AuthServiceImp(this._storageManager, this._leetcodeApi);
  @override
  Future<AuthenticationStatus> checkAuthentication() async {
    final credentials =
        await _storageManager.getObjectMap(_storageManager.leetcodeSession);
    final leetcodeUserName =
        await _storageManager.getString(_storageManager.leetcodeUserName);
    if (leetcodeUserName == null) {
      return UnAuthenticatedStatus();
    }
    if (credentials != null) {
      return LeetcodeAccountAuthenticated(
        credentials: credentials,
        userName: leetcodeUserName,
      );
    }
    return LeetcodeUsernameAuthenticated(userName: leetcodeUserName);
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
    return UnAuthenticatedStatus();
  }
}

extension AuthServiceStorageExtension on StorageManager {
  String get leetcodeSession => 'leetcode_session';
  String get leetcodeUserName => 'leetcode_username';
}
