import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/register/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
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
  String? imageUrl = 'https://firebasestorage.googleapis.com/'
      'v0/b/test-project-eeb99.appspot.com/o/user_image%2Ftest%'
      '2Fimage_picker127597264248855870.jpg'
      '?alt=media&token=7e20acfe-a7c7-489e-991b-f8340faa7008';
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
      emit(NextPageSuccessesState());
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

  getImageFromGallery() {
    emit(ImageSelectionLoadingState());
    final pickedFile = picker
        .getImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      image = File(value!.path);
      print('1 => ${value.path}');
      print('2 => ${image!.path}');
      uploadImage(Uri.file(image!.path).pathSegments.last).then((value) {
        emit(ImageSelectionSuccessesState());
      }).catchError((error) {
        emit(ImageSelectionErrorState());
      });
      print('4 = > $imageUrl');
      print('5 = >${ME.toMap()}');
    }).catchError((error) {
      emit(ImageSelectionErrorState());
    });
  }

  uploadImage(String? path) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user_image/test/$path')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((url) {
        print('3 => $url');
        imageUrl = url;
        ME.imageUrl = url;
        print('4 = > $imageUrl');
        print('5 = >${ME.toMap()}');
      });
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
      emit(LoginSuccessesState());
    }).catchError((error) {
      emit(LoginErrorState());
    });
  }
}

// Future<void> getImageFromCamera() async {
//   emit(ImageSelectionLoadingState());
//   final pickedFile = await picker.getImage(source: ImageSource.camera);
//   if (pickedFile != null) {
//     image = File(pickedFile.path);
//     if (uploadImage(Uri.file(pickedFile.path).pathSegments.last))
//       emit(ImageSelectionSuccessesState());
//     else
//       emit(ImageSelectionErrorState());
//     print('1 => ${pickedFile.path}');
//   } else {
//     print('No image selected.');
//     emit(ImageSelectionErrorState());
//   }
//   print(ME.toMap());
// }
