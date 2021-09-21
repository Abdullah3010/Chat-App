import 'package:chat/modules/friends/add_friend_screen.dart';
import 'package:chat/modules/friends/cubit/cubit.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/states.dart';
import 'friend_request_screen.dart';

class MyFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FriendsCubit cubit;
    String color = "";

    return BlocProvider(
      create: (context) => FriendsCubit(),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> users) {
          if (users.hasError) return ErrorScreen();
          if (users.connectionState == ConnectionState.waiting) return Center();
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('${ME.uId}')
                .collection('sent_request')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> sentRequest) {
              if (sentRequest.hasError) return ErrorScreen();
              if (sentRequest.connectionState == ConnectionState.waiting)
                return Center();

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('${ME.uId}')
                    .collection('friend_request')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> friendRequest) {
                  if (friendRequest.hasError) return ErrorScreen();
                  if (friendRequest.connectionState == ConnectionState.waiting)
                    return LoadingScreen();

                  return BlocConsumer<FriendsCubit, FriendsStats>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      cubit = FriendsCubit.get(context);

                      if (state is AddFriendsInitialStats) {
                        cubit.changeColor(friendRequest.data!.docs.isEmpty);
                        cubit.emit(AcceptFriendSuccessStats());
                      }
                      color = cubit.color;
                      return Scaffold(
                        appBar: AppBar(
                          titleSpacing: 20,
                          title: Text(
                            'Add Friend',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          actions: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: IconTheme(
                                  data: Theme.of(context).iconTheme.copyWith(
                                        color: color.compareTo('red') == 0
                                            ? Colors.red
                                            : null,
                                      ),
                                  child: Icon(
                                    color.compareTo('red') == 0
                                        ? Icons.notifications_active_rounded
                                        : Icons.notifications,
                                  ),
                                ),
                                onPressed: () {
                                  navigate(
                                      context,
                                      FriendRequest(
                                        friendRequest.data!.docs,
                                      ));
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: IconTheme(
                                  data: Theme.of(context).iconTheme,
                                  child: Icon(Icons.person_add),
                                ),
                                onPressed: () {
                                  navigate(context, AddFriend());
                                },
                              ),
                            ),
                          ],
                        ),
                        body: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: FRIENDS.isEmpty
                              ? Center()
                              : ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        circleImage(
                                          context: context,
                                          image: FRIENDS[index].imageUrl!,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: 150,
                                          child: Text(
                                            FRIENDS[index].username!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Spacer(),
                                        ((state is RemoveFriendLoadingStats) &&
                                                (cubit.removedFriendsIndex
                                                    .contains(index)))
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : defaultButton(
                                                width: 80,
                                                addIcon: true,
                                                icon: Icons
                                                    .delete_outline_rounded,
                                                iconColor: Colors.white,
                                                iconSize: 30,
                                                background:
                                                    Colors.red.withOpacity(0.8),
                                                splashColor: Colors.white
                                                    .withOpacity(0.2),
                                                onPressed: () {
                                                  showMyDialog(
                                                    context: context,
                                                    title: 'Are you sure',
                                                    content:
                                                        'you want to delete your friend ${FRIENDS[index].username!}?',
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          defaultButton(
                                                            text: 'Yes',
                                                            isUpperCase: false,
                                                            width: 130,
                                                            background:
                                                                Colors.red,
                                                            onPressed: () {
                                                              cubit.removeFriend(
                                                                  FRIENDS[index]
                                                                      .uId,
                                                                  FRIENDS[index]
                                                                      .chatID,
                                                                  index);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          Spacer(),
                                                          defaultButton(
                                                            text: 'No',
                                                            isUpperCase: false,
                                                            width: 130,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                      ],
                                    );
                                  },
                                  itemCount: FRIENDS.length,
                                ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/**
 *
 * return
    Padding(
    padding: const EdgeInsets.all(20),
    child: ListView.separated(
    physics: BouncingScrollPhysics(),
    separatorBuilder: (context, index) {
    if (cubit.unfriendUsers[index].uId!.compareTo(
    'n8pMjy0PdBN94apW97QeDRS6VIZ2') ==
    0) return Center();
    return Divider(
    height: 35,
    thickness: 2,
    indent: 20,
    endIndent: 20,
    );
    },
    itemBuilder: (context, index) {
    if (cubit.unfriendUsers[index].uId!.compareTo(
    'n8pMjy0PdBN94apW97QeDRS6VIZ2') ==
    0) return Center();
    return Row(
    children: [
    circleImage(
    context: context,
    image: cubit.unfriendUsers[index].imageUrl!,
    ),
    SizedBox(
    width: 15,
    ),
    Container(
    width: 180,
    child: Text(
    cubit.unfriendUsers[index].username!,
    style: Theme.of(context)
    .textTheme
    .headline4!,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    Spacer(),
    if ((state is SendRequestLoadingStats &&
    cubit.sentIndex.contains(index)) ||
    (state is RemoveFriendLoadingStats &&
    cubit.sentIndex.contains(index)))
    Container(
    width: 80,
    child: Center(
    child: CircularProgressIndicator(),
    ),
    ),
    if (state is SendRequestSuccessStats &&
    cubit.sentIndex.contains(index))
    defaultButton(
    width: 80,
    addIcon: true,
    icon: Icons.check_circle_outline_rounded,
    iconSize: 34,
    iconColor: Colors.greenAccent,
    background: Theme.of(context)
    .scaffoldBackgroundColor,
    onPressed: () {
    showMyDialog(
    context: context,
    title: 'Are you sure',
    content:
    'you want to cancel your friend request?',
    actions: [
    Row(
    mainAxisAlignment:
    MainAxisAlignment.center,
    children: [
    defaultButton(
    text: 'Yes',
    isUpperCase: false,
    width: 100,
    background: Colors.red,
    onPressed: () {
    cubit.removeFriend(
    cubit
    .unfriendUsers[
    index]
    .uId,
    index);
    Navigator.pop(context);
    },
    ),
    Spacer(),
    defaultButton(
    text: 'No',
    isUpperCase: false,
    width: 100,
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    ],
    ),
    ],
    );
    },
    ),
    if (!cubit.sentIndex.contains(index) ||
    (!cubit.sentIndex.contains(index) &&
    state is RemoveFriendSuccessStats))
    defaultButton(
    width: 80,
    addIcon: true,
    icon: Icons.add,
    iconColor: Theme.of(context).primaryColor,
    background: Color.fromRGBO(0, 0, 0, 0),
    iconSize: 34,
    onPressed: () {
    cubit.sendFriendRequest(
    to: cubit.unfriendUsers[index].uId!,
    name: cubit
    .unfriendUsers[index].username!,
    image: cubit
    .unfriendUsers[index].imageUrl!,
    index: index,
    );
    },
    ),
    ],
    );
    },
    itemCount: cubit.unfriendUsers.length,
    ),
    ),
 * */
