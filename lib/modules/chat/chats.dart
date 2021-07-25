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

    return BlocProvider(
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
    );
  }

  Widget userData({
    required BuildContext context,
    required String image,
    required String username,
    required String lastMessage,
    bool isOnline = false,
  }) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 40,
              child: CircleAvatar(
                radius: 37,
                backgroundImage: NetworkImage(
                  image,
                ),
              ),
            ),
            if (isOnline)
              CircleAvatar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                radius: 13,
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 10,
                ),
              ),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 3),
              child: Container(
                width: 150,
                child: Text(
                  lastMessage,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
