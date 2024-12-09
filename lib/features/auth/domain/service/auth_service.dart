abstract interface class AuthService {
  Future<AuthenticationStatus> checkAuthentication();
  Future<AuthenticationStatus> loginWithLeetcodeAccount(
    Map<String, dynamic> credentials,
  );
  Future<AuthenticationStatus> loginWithLeetcodeUserName(
    String leetcodeUsername,
  );
  Future<AuthenticationStatus> logout();
}

sealed class AuthenticationStatus {}

class LeetcodeAccountAuthenticated extends AuthenticationStatus {
  final Map<String, dynamic> credentials;
  final String userName;

  LeetcodeAccountAuthenticated({
    required this.credentials,
    required this.userName,
  });
}

class LeetcodeUsernameAuthenticated extends AuthenticationStatus {
  final String userName;

  LeetcodeUsernameAuthenticated({required this.userName});
}

class UnAuthenticatedStatus extends AuthenticationStatus {}
