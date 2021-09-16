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
import 'package:intl/intl.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit();
    String? receiverId;

    CHATS.forEach((element) {
      print(element.id);
    });
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          'Chats',
          style: Theme.of(context).textTheme.headline3,
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
                        .orderBy('last_seen', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                      if (users.hasError) return ErrorScreen();
                      if (users.connectionState == ConnectionState.waiting)
                        return LoadingScreen();
                      if (friends.data!.docs.isEmpty) return Center();
                      cubit.getUsersState(users.data!, friends.data!, CHATS);
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    circleImage(
                                        context: context,
                                        image: FRIENDS[index].imageUrl!),
                                    if (FRIENDS[index].state == 'Online')
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        radius: 10,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.greenAccent,
                                          radius: 7,
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
                                      FRIENDS[index].username!,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3),
                                      child: Container(
                                        width: 150,
                                        child: Text(
                                          FRIENDS[index].lastMessage!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('chat')
                                        .doc('${FRIENDS[index].chatID}')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            unread) {
                                      if (unread.connectionState ==
                                          ConnectionState.waiting)
                                        return Container();
                                      if (unread
                                              .data!['${ME.uId}' + 'unread'] !=
                                          0)
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            radius: 12,
                                            child: Text(
                                              unread
                                                  .data!['${ME.uId}' + 'unread']
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                        );
                                      return Center();
                                    }),
                                Text(
                                  getLastSeen(FRIENDS[index].lastSeen!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                            onTap: () {
                              receiverId = FRIENDS[index].uId!;
                              cubit.getChatId(
                                receiverId: FRIENDS[index].uId!,
                                image: FRIENDS[index].imageUrl!,
                                name: FRIENDS[index].username!,
                                online: FRIENDS[index].state == 'Online',
                                lastseen: getLastSeen(FRIENDS[index].lastSeen!),
                              );
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

  String getLastSeen(Timestamp last) {
    DateTime now = Timestamp.now().toDate();
    DateTime lastSeen = last.toDate();

    if (lastSeen.day == now.day)
      return DateFormat('hh:mm a').format(lastSeen);
    else if (lastSeen.day == now.day - 1)
      return 'Yesterday';
    else
      return DateFormat('MM/dd/yy').format(lastSeen);
  }
}
