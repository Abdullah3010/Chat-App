import 'package:bloc/bloc.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  String chatId = '';
  var collection = FirebaseFirestore.instance.collection('chat').snapshots();

  Future<String> getChatId(String? receiverId) async {
    emit(ChatLoadState());

    collection.forEach((element) {
      element.docs.forEach((element) {
        if (element.id.contains(receiverId!) && element.id.contains(ME.uId!)) {
          chatId = element.id;
          print(' == $chatId');
          emit(ChatSuccessState());
        }
      });
    });
    print(' ==2 $chatId');
    return chatId;
  }
}
