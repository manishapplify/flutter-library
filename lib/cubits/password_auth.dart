import 'package:components/cubits/models/forgot_password.dart';
import 'package:components/services/persistence.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordAuthState {
  PasswordAuthState({
    this.forgotPasswordToken,
  });

  final ForgotPasswordToken? forgotPasswordToken;

  bool get isTokenGenerated => forgotPasswordToken is ForgotPasswordToken;
}

class PasswordAuthCubit extends Cubit<PasswordAuthState> {
  PasswordAuthCubit(Persistence persistence)
      : _persistence = persistence,
        super(PasswordAuthState()) {
    emit(PasswordAuthState(
        forgotPasswordToken: _persistence.fetchForgotPasswordToken()));
  }

  final Persistence _persistence;

  void setToken({
    required String token,
    required String email,
  }) {
    emit(PasswordAuthState(
        forgotPasswordToken: ForgotPasswordToken(token: token, email: email)));
  }

  void resetToken() => emit(PasswordAuthState());
}
