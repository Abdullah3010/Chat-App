import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void getUsersState(List<QueryDocumentSnapshot<Object?>> users) {
    users.forEach((user) {
      FRIENDS.forEach((friend) {
        if (user.id == friend.uId) {
          if (user['state'].toString().toLowerCase() == 'online') {
            friend.state = 'online';
          } else {
            friend.state = user['state'].toString().toLowerCase();
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
}
