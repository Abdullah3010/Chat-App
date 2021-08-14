import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/chat/user_chat.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit();
    String? receiverId;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => ChatCubit(),
        child: BlocConsumer<ChatCubit, ChatStates>(
          listener: (context, state) {
            if (state is ChatSuccessState)
              navigate(context, UserChat(receiverId!, cubit));
            print(receiverId);
          },
          builder: (context, state) {
            cubit = ChatCubit.get(context);
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('${ME.uId}')
                    .collection('friends')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> friends) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                      if (users.hasError) return ErrorScreen();
                      if (users.connectionState == ConnectionState.waiting)
                        return LoadingScreen();
                      cubit.getUsersState(
                        users.data!.docs,
                        friends.data!.docs,
                      );

                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          if (friends.data!.docs[index].id != 'null')
                            return InkWell(
                              child: userData(
                                context: context,
                                image: friends.data!.docs[index]['image_url'],
                                username: friends.data!.docs[index]['username'],
                                lastMessage: friends.data!.docs[index]
                                    ['last_message'],
                                isOnline: cubit.states[index] == 'online',
                              ),
                              onTap: () {
                                receiverId = friends.data!.docs[index].id;
                                cubit.getChatId(friends.data!.docs[index].id);
                              },
                            );
                          return Center();
                        },
                        itemCount: friends.data!.docs.length,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
