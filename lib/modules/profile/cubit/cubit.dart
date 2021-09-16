import 'dart:io';

import 'package:chat/modules/profile/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileCubit extends Cubit<ProfileStats> {
  ProfileCubit() : super(ProfileInitialStats());

  static ProfileCubit get(context) => BlocProvider.of(context);

  String chatId = '';

  void removeFriend(String? id, int index) {
    emit(RemoveFriendLoadingStats());
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .collection('friends')
        .doc('$id')
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('$id')
          .collection('friends')
          .doc('${ME.uId}')
          .delete()
          .then((value) {
        FirebaseFirestore.instance.collection('chat').get().then((value) {
          value.docs.forEach((element) {
            if (element.id.contains(id!) && element.id.contains(ME.uId!)) {
              chatId = element.id;
            }
          });
          FirebaseFirestore.instance
              .collection('chat')
              .doc('$chatId')
              .delete()
              .catchError((error) {
            emit(RemoveFriendErrorStats());
          });
        }).catchError((error) {
          emit(RemoveFriendErrorStats());
        });
      }).catchError((error) {
        emit(RemoveFriendErrorStats());
      });
      FRIENDS.removeAt(index);
      emit(RemoveFriendSuccessStats());
    }).catchError((error) {
      emit(RemoveFriendErrorStats());
    });
  }

  void changeName(String newName) {
    emit(ChangeNameLoadingStats());
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .update({'username': newName}).then((value) {
      ME.username = newName;
      emit(ChangeNameSuccessStats());
    }).catchError((error) {
      emit(ChangeNameErrorStats());
    });
  }

  File? image;
  ImagePicker picker = ImagePicker();

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
        FirebaseFirestore.instance.collection('users').doc('${ME.uId}').update({
          'image_url': url,
        });
      }).catchError((error) {
        emit(ImageSelectionErrorState());
      });
    }).catchError((error) {
      emit(ImageSelectionErrorState());
    });
  }
}
