part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckStatus extends AuthEvent {}

class AuthLoginWithLeetcode extends AuthEvent {
  final Map<String, dynamic> credentials;

  const AuthLoginWithLeetcode({required this.credentials});
  @override
  List<Object?> get props => [credentials];
}

class AuthLoginWithLeetcodeUserName extends AuthEvent {
  final String leetcodeUserName;

  const AuthLoginWithLeetcodeUserName({required this.leetcodeUserName});
  @override
  List<Object?> get props => [leetcodeUserName];
}

class AuthLogout extends AuthEvent {}
