import 'package:chat/modules/profile/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
}
