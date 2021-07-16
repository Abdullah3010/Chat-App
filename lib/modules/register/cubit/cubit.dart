import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/register/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  late int errorMessageIndex;
  List<String> errorMessage = [
    'The password provided is too weak.',
    'The account already exists for that email.',
    'Something wrong'
  ];
  File? image;
  ImagePicker picker = ImagePicker();

  void changePasswordState() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  void changePasswordFocus() {
    passwordFocus.requestFocus();
    emit(ChangeFocusNodeState());
  }

  void changeEmailFocus() {
    emailFocus.requestFocus();
    emit(ChangeFocusNodeState());
  }

  void nextPage({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(NextPageLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUser(
        username: username,
        email: email,
        password: password,
        uId: value.user!.uid,
      );
      LocalData.putData(
        key: 'uid',
        value: value.user!.uid,
      ).then((value) {
        emit(NextPageSuccessesState());
      }).catchError((_) {
        emit(NextPageErrorState());
      });
    }).catchError((error) {
      if (error is FirebaseAuthException) {
        errorMessageIndex = errorName(error.code);
        emit(NextPageErrorState());
      }
    });
  }

  int errorName(String error) {
    if (error.contains('weak-password')) return 0;
    if (error.contains('email-already-in-use')) return 1;
    return 2;
  }

  void createUser({
    String? username,
    String? email,
    String? password,
    String? uId,
  }) {
    ME = NewUser(
      username: username,
      email: email,
      password: password,
      uId: uId,
    );
  }

  Future<void> getImageFromGallery() async {
    emit(ImageSelectionLoadingState());
    final pickedFile = await picker
        .getImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      image = File(value!.path);
      uploadImage(Uri.file(image!.path).pathSegments.last);
    }).catchError((error) {
      emit(ImageSelectionErrorState());
    });
    emit(ImageSelectionSuccessesState());
  }

  Future<void> getImageFromCamera() async {
    emit(ImageSelectionLoadingState());
    final pickedFile = await picker
        .getImage(
      source: ImageSource.camera,
    )
        .then((value) {
      image = File(value!.path);
      uploadImage(Uri.file(image!.path).pathSegments.last);
    }).catchError((error) {
      emit(ImageSelectionErrorState());
    });
    emit(ImageSelectionSuccessesState());
  }

  Future<void> uploadImage(String? path) async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_image/$path')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        ME.imageUrl = url;
      }).catchError((error) {
        emit(ImageSelectionErrorState());
      });
    }).catchError((error) {
      emit(ImageSelectionErrorState());
    });
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
      value.user!.sendEmailVerification();
      FirebaseFirestore.instance
          .collection('users')
          .doc('${ME.uId}')
          .set(ME.toMap())
          .then((value) {
        emit(LoginSuccessesState());
      }).catchError((error) {
        emit(LoginErrorState());
      });
    }).catchError((error) {
      emit(LoginErrorState());
    });
  }
}
