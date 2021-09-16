import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/chat/chats.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/friends/add_friend_screen.dart';
import 'package:chat/modules/profile/profile_screen.dart';
import 'package:chat/modules/settings/settings_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  String chatId = '';
  String imageUrl = '';
  String username = '';
  String lastSeen = '';
  bool isOnline = false;
  FirebaseFirestore fire = FirebaseFirestore.instance;

  void getChatId(
      {required String receiverId,
      required String image,
      required String name,
      required bool online,
      required String lastseen}) {
    CHATS.forEach((element) {
      if (element.id.contains(receiverId) && element.id.contains(ME.uId!)) {
        chatId = element.id;
        imageUrl = image;
        username = name;
        isOnline = online;
        lastSeen = lastseen;
      }
      print(element.id);
    });
    emit(ChatSuccessState());
  }

  void sendMessage({
    required String message,
    String type = 'text',
    String image = '',
    required String to,
  }) {
    bool? isInside;
    int unread = 0;
    fire.collection('chat').doc('$chatId').get().then((value) {
      isInside = value.data()!['$to' + 'L'] == 'inside';
      unread = value.data()!['$to' + 'unread'];
    });

    Message m = Message(
        message: message,
        from: ME.uId,
        to: to,
        type: type,
        image: image,
        time: Timestamp.now());
    emit(MessageSendLoadState());
    fire
        .collection('chat')
        .doc('$chatId')
        .collection('messages')
        .add(m.toMap())
        .then((value) {
      fire
          .collection('users')
          .doc('${ME.uId}')
          .collection('friends')
          .doc('$to')
          .update({'last_message': message}).then((value) {
        fire
            .collection('users')
            .doc('$to')
            .collection('friends')
            .doc('${ME.uId}')
            .update({'last_message': message}).then((value) {
          if (!isInside!) {
            fire
                .collection('chat')
                .doc('$chatId')
                .update({'$to' + 'unread': unread + 1});
            print("dfsdfsdf");
          }
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
  List<Widget> screens = [AddFriend(), Chats(), Profile(), SettingsScreen()];

  void changeScreen(int index) {
    currentIndex = index;
    emit(ChangeScreenState());
  }

  Future<void> getUsersState(
    QuerySnapshot<Object?> users,
    QuerySnapshot<Object?> friends,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chats,
  ) async {
    FRIENDS.clear();
    friends.docs.forEach((friend) {
      users.docs.forEach((user) {
        if (user.id == friend.id) {
          print(friend.id);
          CHATS.forEach((element) {
            if (element.id.contains(user.id) && element.id.contains(ME.uId!)) {
              FRIENDS.add(
                Friends(
                    username: user['username'],
                    uId: user.id,
                    state: user['state'],
                    imageUrl: user['image_url'],
                    lastMessage: friend['last_message'],
                    lastSeen: user['last_seen'],
                    chatID: element.id),
              );
            }
          });
        }
      });
    });
    FRIENDS.sort((a, b) => b.lastSeen!.compareTo(a.lastSeen!));
  }

  void setTyping() {
    fire.collection('chat').doc('$chatId').update({'${ME.uId}': 'typing...'});
  }

  void removeTyping() {
    fire.collection('chat').doc('$chatId').update({'${ME.uId}': ''});
  }
}
