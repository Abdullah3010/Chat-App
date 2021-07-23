import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppCubit extends Cubit<ChatAppStates> {
  ChatAppCubit() : super(ChatAppInitialState());

  static ChatAppCubit get(context) => BlocProvider.of(context);

  void getData(String? uid) {
    emit(GetDataLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc('$uid')
        .get()
        .then((value) {
      ME = NewUser.fromJson(value.data()!);
      ME.uId = uid;
      FRIENDS.clear();
      FirebaseFirestore.instance
          .collection('users')
          .doc('$uid')
          .collection('friends')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FRIENDS.add(Friends.fromJson(
            element.data(),
            element.id,
          ));
        });
        emit(GetDataSuccessState());
      }).catchError((error) {
        emit(GetDataErrorState());
        ;
      });
    }).catchError((error) {
      emit(GetDataErrorState());
    });
  }
}
