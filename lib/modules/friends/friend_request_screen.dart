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
                List<QueryDocumentSnapshot<Object?>> requests =
                    snapshot.data!.docs;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          cubit.acceptRequest(
                            requests[index].id,
                            requests[index]['username'],
                            requests[index]['image_url'],
                          );
                          requests.removeAt(index);
                        } else {
                          cubit.cancelRequest(requests[index].id);
                          requests.removeAt(index);
                        }
                      },
                      background: Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 30,
                        ),
                      ),
                      secondaryBackground: Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete_rounded,
                          size: 30,
                        ),
                      ),
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              circleImage(
                                context: context,
                                image: requests[index]['image_url'],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                requests[index]['username'],
                                style: Theme.of(context).textTheme.headline4!,
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    final snackBar = SnackBar(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      content: Text(
                                          'Swipe left to remove friends request'),
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: Icon(Icons.arrow_back_rounded),
                                  iconSize: 30,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.green,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    final snackBar = SnackBar(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      content: Text(
                                          'Swipe right to accept friends request'),
                                      duration: Duration(seconds: 3),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: Icon(Icons.arrow_forward_rounded),
                                  iconSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: requests.length,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
