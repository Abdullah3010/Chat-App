import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/login/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  late String id;
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
      id = value.user!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc('${value.user!.uid}')
          .get()
          .then((value) {
        ME = NewUser.fromJson(value.data()!);
        ME.uId = id;
        LocalData.putData(
          key: 'uid',
          value: id,
        ).then((value) {
          emit(LoginSuccessesState());
        }).catchError((_) {
          emit(LoginErrorState());
        });
      }).catchError((error) {
        emit(LoginErrorState());
      });
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
