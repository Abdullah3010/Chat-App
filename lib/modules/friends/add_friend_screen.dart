import 'package:chat/modules/friends/cubit/cubit.dart';
import 'package:chat/modules/friends/cubit/states.dart';
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
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: BlocProvider(
          create: (context) => AddFriendCubit(),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
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
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> sentRequest) {
                      if (sentRequest.hasError) return ErrorScreen();
                      if (sentRequest.connectionState ==
                          ConnectionState.waiting) return LoadingScreen();

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
                                indent: 30,
                                endIndent: 30,
                              ),
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundImage: NetworkImage(
                                          cubit.unfriendUsers[index].imageUrl!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      cubit.unfriendUsers[index].username!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    if ((state is SendRequestLoadingStats &&
                                            cubit.sentIndex.contains(index)) ||
                                        (state is RemoveFriendLoadingStats &&
                                            cubit.sentIndex.contains(index)))
                                      Container(
                                        width: 100,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    if (state is SendRequestSuccessStats &&
                                        cubit.sentIndex.contains(index))
                                      defaultButton(
                                        width: 100,
                                        addIcon: true,
                                        icon:
                                            Icons.check_circle_outline_rounded,
                                        iconSize: 55,
                                        iconColor: Colors.greenAccent,
                                        background: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        onPressed: () {
                                          showMyDialog(
                                            context: context,
                                            title: 'Are you sure',
                                            content:
                                                'you want to cancel your friend request?',
                                            actionAliment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              defaultButton(
                                                text: 'Yes',
                                                isUpperCase: false,
                                                width: 130,
                                                background: Colors.red,
                                                onPressed: () {
                                                  cubit.removeFriend(
                                                      cubit.unfriendUsers[index]
                                                          .uId,
                                                      index);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              defaultButton(
                                                text: 'No',
                                                isUpperCase: false,
                                                width: 130,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    if (!cubit.sentIndex.contains(index) ||
                                        (!cubit.sentIndex.contains(index) &&
                                            state is RemoveFriendSuccessStats))
                                      defaultButton(
                                        width: 100,
                                        addIcon: true,
                                        icon: Icons.add,
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
                            );
                          });
                    },
                  );
                }),
          )),
    );
  }
}
