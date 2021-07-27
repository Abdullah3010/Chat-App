import 'package:chat/modules/friends/cubit/cubit.dart';
import 'package:chat/modules/friends/cubit/states.dart';
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
    return BlocProvider(
      create: (context) => AddFriendCubit(),
      child: BlocConsumer<AddFriendCubit, AddFriendsStats>(
        listener: (context, state) {},
        builder: (context, state) {
          cubit = AddFriendCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(20),
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return ErrorScreen();
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LoadingScreen();

                cubit.getUnfriendUsers(snapshot.data!.docs);

                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
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
                          width: 10,
                        ),
                        Text(
                          cubit.unfriendUsers[index].username!,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                  itemCount: cubit.unfriendUsers.length,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
