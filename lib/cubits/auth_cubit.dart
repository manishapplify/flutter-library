import 'package:components/cubits/user.dart';
import 'package:components/services/persistence.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  AuthState({this.user});

  final User? user;

  bool get isAuthorized => user is User;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(Persistence persistence)
      : _persistence = persistence,
        super(AuthState()) {
    emit(AuthState(user: _persistence.fetchUser()));
  }

  final Persistence _persistence;

  void signupOrLogin(User user) {
    emit(AuthState(user: user));
    _persistence.saveUser(user);
  }

  void logout() {
    emit(AuthState());
    _persistence.deleteUser();
  }
}
