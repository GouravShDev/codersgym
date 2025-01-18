part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

sealed class Authenticated extends AuthState {
  final String userName;

  const Authenticated({required this.userName});
  @override
  List<Object> get props => [userName];
}

class UnAuthenticated extends AuthState {}

class AuthenticatedWithLeetcodeAccount extends Authenticated {
  final Map<String, dynamic> leetcodeSession;
  const AuthenticatedWithLeetcodeAccount({
    required this.leetcodeSession,
    required super.userName,
  });

  @override
  List<Object> get props => [leetcodeSession, userName];

  @override
  String toString() {
    return 'AuthenticatedWithLeetcodeAccount(userName: $userName)';
  }
}

class AuthenticatedWithLeetcodeUserName extends Authenticated {
  const AuthenticatedWithLeetcodeUserName({
    required super.userName,
  });
  @override
  List<Object> get props => [userName];

  @override
  String toString() {
    return 'AuthenticatedWithLeetcodeUserName(userName: $userName)';
  }
}
