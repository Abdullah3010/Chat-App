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

    FRIENDS.forEach((element) {
      print(element.username);
    });

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
                  if (friends.hasError) return ErrorScreen();
                  if (friends.connectionState == ConnectionState.waiting)
                    return Center();
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                      if (users.hasError) return ErrorScreen();
                      if (users.connectionState == ConnectionState.waiting)
                        return LoadingScreen();
                      cubit.getUsersState(
                        users.data!,
                        friends.data!,
                      );
                      if (friends.data!.docs.isEmpty) return Center();
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: userData(
                              context: context,
                              image: FRIENDS[index]
                                  .imageUrl!, //friends.data!.docs[index]['image_url'],
                              username: FRIENDS[index]
                                  .username!, //friends.data!.docs[index]['username'],
                              lastMessage: FRIENDS[index]
                                  .lastMessage!, //friends.data!.docs[index]
                              //['last_message'],
                              isOnline: FRIENDS[index].state == 'Online',
                            ),
                            onTap: () {
                              receiverId = FRIENDS[index].uId!;
                              cubit.getChatId(
                                  receiverId: FRIENDS[index].uId!,
                                  image: FRIENDS[index].imageUrl!,
                                  name: FRIENDS[index].username!,
                                  online: FRIENDS[index].state == 'Online');
                            },
                          );
                        },
                        itemCount: FRIENDS.length,
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
