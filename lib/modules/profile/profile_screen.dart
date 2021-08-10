import 'package:chat/modules/profile/cubit/cubit.dart';
import 'package:chat/modules/profile/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileStats>(
          listener: (context, state) {},
          builder: (context, state) {
            ProfileCubit cubit = ProfileCubit.get(context);
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 5,
                              right: 5,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              child: IconButton(
                                splashRadius: 30,
                                icon: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 55,
                          ),
                          Text(
                            '${ME.username}',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            iconSize: 30,
                            color: Theme.of(context).primaryColor,
                            splashColor: Color.fromRGBO(10, 199, 255, 0.5),
                            splashRadius: 25,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    height: 50,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Friends',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                child: CircleAvatar(
                                  radius: 37,
                                  backgroundImage: NetworkImage(
                                    FRIENDS[index].imageUrl!,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                FRIENDS[index].username!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              defaultButton(
                                width: 120,
                                addIcon: true,
                                icon: Icons.delete_outline_rounded,
                                iconColor: Colors.white,
                                iconSize: 35,
                                background: Colors.red.withOpacity(0.9),
                                splashColor: Colors.white.withOpacity(0.2),
                                onPressed: () {
                                  showMyDialog(
                                    context: context,
                                    title: 'Are you sure',
                                    content:
                                        'you want to delete your friend ${FRIENDS[index].username!}?',
                                    actionAliment: MainAxisAlignment.center,
                                    actions: [
                                      defaultButton(
                                        text: 'Yes',
                                        isUpperCase: false,
                                        width: 130,
                                        background: Colors.red,
                                        onPressed: () {
                                          cubit.removeFriend(
                                              FRIENDS[index].uId, index);
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
                            ],
                          );
                        },
                        itemCount: FRIENDS.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
