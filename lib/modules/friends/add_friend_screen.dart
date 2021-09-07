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
  @override
  Widget build(BuildContext context) {
    AddFriendCubit cubit;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Add Friend',
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                size: 28,
              ),
              onPressed: () {
                navigate(context, FriendRequest());
              },
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => AddFriendCubit(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> users) {
              if (users.hasError) return ErrorScreen();
              if (users.connectionState == ConnectionState.waiting)
                return LoadingScreen();

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('${ME.uId}')
                    .collection('sent_request')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> sentRequest) {
                  if (sentRequest.hasError) return ErrorScreen();
                  if (sentRequest.connectionState == ConnectionState.waiting)
                    return LoadingScreen();

                  return BlocConsumer<AddFriendCubit, AddFriendsStats>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      cubit = AddFriendCubit.get(context);
                      if (state is AddFriendsInitialStats)
                        cubit.getUnfriendUsers(
                          users.data!.docs,
                          sentRequest.data!.docs,
                        );
                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                          height: 35,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              circleImage(
                                image: cubit.unfriendUsers[index].imageUrl!,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                cubit.unfriendUsers[index].username!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
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
                                  background:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                                                    cubit.unfriendUsers[index]
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
                                      name:
                                          cubit.unfriendUsers[index].username!,
                                      image:
                                          cubit.unfriendUsers[index].imageUrl!,
                                      index: index,
                                    );
                                  },
                                ),
                            ],
                          );
                        },
                        itemCount: cubit.unfriendUsers.length,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
