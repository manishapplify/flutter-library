import 'package:components/cubits/models/user.dart';
import 'package:components/services/api/api.dart';
import 'package:components/services/persistence.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  AuthState({this.user});

  final User? user;

  bool get isAuthorized => user is User;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required Persistence persistence,
    required Api api,
  })  : _persistence = persistence,
        _api = api,
        super(AuthState()) {
    final User? user = _persistence.fetchUser();

    emit(AuthState(user: user));
    if (user is User) {
      _api.addAuthorizationHeader(user.accessToken);
    }
  }

  final Persistence _persistence;
  final Api _api;

  void signupOrLogin(User user) {
    emit(AuthState(user: user));
    _api.addAuthorizationHeader(user.accessToken);
    _persistence.saveUser(user);
  }

  void logoutOrDeleteAccount() {
    emit(AuthState());
    _api.removeAuthorizationHeader();
    _persistence.deleteUser();
  }
}
