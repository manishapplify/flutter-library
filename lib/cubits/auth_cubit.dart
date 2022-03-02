import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.login);

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp()=>
    emit(AuthState.confirmSignUp);
}