import 'package:chat/models/user.dart';
import 'package:chat/modules/friends/cubit/cubit.dart';
import 'package:chat/modules/friends/cubit/states.dart';
import 'package:chat/modules/friends/friend_request_screen.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFriend extends StatelessWidget {
  // final List<Unfriends> unfriendUsers;
  // AddFriend(this.unfriendUsers);

  @override
  Widget build(BuildContext context) {
    FriendsCubit cubit;
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
                        cubit.getUnfriendUsers(users.data!.docs,
                            sentRequest.data!.docs, friendRequest.data!.docs);

                        cubit.changeColor(friendRequest.data!.docs.isEmpty);
                      }

                      return Scaffold(
                        appBar: AppBar(
                          titleSpacing: 20,
                          title: Text(
                            'Add Friend',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        body: Padding(
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
                                      (state is RemoveFriendRequestLoadingStats &&
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
                                                    cubit.removeFriendRequest(
                                                      cubit.unfriendUsers[index]
                                                          .uId,
                                                      index,
                                                    );
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
                                          state
                                              is RemoveFriendRequestSuccessStats))
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
