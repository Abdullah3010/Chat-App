import 'package:bloc/bloc.dart';
import 'package:chat/modules/login/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  FocusNode passwordFocus = FocusNode();
  late int errorMessageIndex;
  List<String> errorMessage = [
    'Wrong password.',
    'Invalid email.',
    'This user dosen\'t exist try to registering first.',
    'Something wrong'
  ];

  void changePasswordState() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  void changeFocus() {
    passwordFocus.requestFocus();
    emit(ChangeFocusNodeState());
  }

  void login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(LoginSuccessesState());
    }).catchError((error) {
      errorMessageIndex = errorName(error.toString());
      print(errorMessageIndex);
      emit(LoginErrorState());
    });
  }

  int errorName(String error) {
    if (error.contains('wrong-password')) return 0;
    if (error.contains('invalid-email')) return 1;
    if (error.contains('user-not-found')) return 2;
    return 3;
  }
}
