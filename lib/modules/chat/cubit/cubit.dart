import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/chat/chat_screen.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/friends/add_friend_screen.dart';
import 'package:chat/modules/profile/profile_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  String chatId = '';

  void getChatId(String? receiverId) {
    FirebaseFirestore.instance.collection('chat').get().then((value) {
      value.docs.forEach((element) {
        if (element.id.contains(receiverId!) && element.id.contains(ME.uId!)) {
          chatId = element.id;
        }
      });
      emit(ChatSuccessState());
    }).catchError((error) {
      emit(ChatErrorState());
    });
  }

  List<String> states = [];

  void getUsersState(
    List<QueryDocumentSnapshot<Object?>> users,
    List<QueryDocumentSnapshot<Object?>> friends,
  ) {
    states.clear();
    friends.forEach((friend) {
      users.forEach((user) {
        if (user.id == friend.id) {
          if (user['state'].toString().toLowerCase() == 'online') {
            states.add('online');
          } else {
            states.add(user['state'].toString().toLowerCase());
          }
        }
      });
    });
  }

  void getFriends() {
    FRIENDS.clear();
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .collection('friends')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FRIENDS.add(Friends.fromJson(
          element.data(),
          element.id,
        ));
      });
    });
  }

  void sendMessage({
    required String message,
    String type = 'text',
    String image = '',
    required String to,
  }) {
    Message m = Message(
        message: message,
        from: ME.uId,
        to: to,
        type: type,
        image: image,
        time: Timestamp.now());
    emit(MessageSendLoadState());
    FirebaseFirestore.instance
        .collection('chat')
        .doc('$chatId')
        .collection('messages')
        .add(m.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('${ME.uId}')
          .collection('friends')
          .doc('$to')
          .update({'last_message': message}).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc('$to')
            .collection('friends')
            .doc('${ME.uId}')
            .update({'last_message': message}).then((value) {
          emit(MessageSendSuccessState());
        }).catchError((error) {
          emit(MessageSendErrorState());
        });
      }).catchError((error) {
        emit(MessageSendErrorState());
      });
    }).catchError((error) {
      emit(MessageSendErrorState());
    });
  }

  int currentIndex = 1;
  List<Widget> screens = [AddFriend(), ChatScreen(), Profile()];
  void changeScreen(int index) {
    currentIndex = index;
    emit(ChangeScreenState());
  }
}
