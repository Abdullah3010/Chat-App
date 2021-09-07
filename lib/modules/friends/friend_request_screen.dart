import 'package:chat/modules/friends/cubit/cubit.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/states.dart';

class FriendRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddFriendCubit cubit;
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => AddFriendCubit(),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc('${ME.uId}')
                .collection('friend_request')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return ErrorScreen();
              if (snapshot.connectionState == ConnectionState.waiting)
                return LoadingScreen();
              return BlocConsumer<AddFriendCubit, AddFriendsStats>(
                listener: (context, state) {},
                builder: (context, state) {
                  cubit = AddFriendCubit.get(context);
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
                            image: snapshot.data!.docs[index]['image_url'],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            snapshot.data!.docs[index]['username'],
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          defaultButton(
                            width: 50,
                            text: 'D',
                            background: Colors.greenAccent,
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          defaultButton(
                            width: 50,
                            text: 'A',
                            background: Colors.red,
                            onPressed: () {},
                          ),
                        ],
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
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
