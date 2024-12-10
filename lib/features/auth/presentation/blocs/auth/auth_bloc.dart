import 'package:bloc/bloc.dart';
import 'package:codersgym/features/auth/domain/service/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      switch (event) {
        case AuthCheckStatus():
          return _onAuthCheckStatus(event, emit);
        case AuthLoginWithLeetcode():
          return _onAuthLoginWithLeetcode(event, emit);
        case AuthLoginWithLeetcodeUserName():
          return _onAuthLoginWithLeetcodeUserName(event, emit);
        case AuthLogout():
          return _onAuthLogout(event, emit);
      }
    });
  }

  bool get isUserAuthenticatedWithLeetcodeAccount =>
      state is AuthenticatedWithLeetcodeAccount;

  void _onAuthCheckStatus(
      AuthCheckStatus event, Emitter<AuthState> emit) async {
    final authStatus = await _authService.checkAuthentication();
    _emitAutheticatedState(emit, authStatus);
  }

  void _onAuthLoginWithLeetcode(
      AuthLoginWithLeetcode event, Emitter<AuthState> emit) async {
    final authStatus = await _authService.loginWithLeetcodeAccount(
      event.credentials,
    );
    _emitAutheticatedState(emit, authStatus);
  }

  void _onAuthLoginWithLeetcodeUserName(
      AuthLoginWithLeetcodeUserName event, Emitter<AuthState> emit) async {
    final authStatus =
        await _authService.loginWithLeetcodeUserName(event.leetcodeUserName);
    _emitAutheticatedState(emit, authStatus);
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    final authStatus = await _authService.logout();
    _emitAutheticatedState(emit, authStatus);
  }

  _emitAutheticatedState(Emitter<AuthState> emit, AuthenticationStatus status) {
    return switch (status) {
      LeetcodeAccountAuthenticated() => {
          emit(
            AuthenticatedWithLeetcodeAccount(
              leetcodeSession: status.credentials,
              userName: status.userName,
            ),
          ),
        },
      LeetcodeUsernameAuthenticated() => {
          emit(AuthenticatedWithLeetcodeUserName(userName: status.userName)),
        },
      UnAuthenticatedStatus() => {
          emit(UnAuthenticated()),
        },
    };
  }
}
