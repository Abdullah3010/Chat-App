import 'package:chat/modules/profile/cubit/cubit.dart';
import 'package:chat/modules/profile/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController changeNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocConsumer<ProfileCubit, ProfileStats>(
          listener: (context, state) {},
          builder: (context, state) {
            ProfileCubit cubit = ProfileCubit.get(context);
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc('${ME.uId}')
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center();
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        circleImage(
                          context: context,
                          image: snapshot.data!['image_url'] ?? "",
                          bigRadius: 83,
                          smallRadius: 80,
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
                              onPressed: () {
                                showMyDialog(
                                  context: context,
                                  title: 'Select image',
                                  content: 'Do you want to select from gallery '
                                      'or tack a new one from camera',
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        defaultButton(
                                          text: 'Gallery',
                                          isUpperCase: false,
                                          addIcon: true,
                                          icon: Icons.image_outlined,
                                          width: 136,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            cubit.getImageFromGallery();
                                          },
                                        ),
                                        Spacer(),
                                        defaultButton(
                                          text: 'Camera',
                                          isUpperCase: false,
                                          addIcon: true,
                                          icon: Icons.camera_alt_outlined,
                                          width: 136,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            cubit.getImageFromCamera();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
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
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        state is ChangeNameLoadingStats
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 9,
                                ),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : IconButton(
                                icon: Icon(Icons.edit),
                                iconSize: 30,
                                color: Theme.of(context).primaryColor,
                                splashColor: Color.fromRGBO(10, 199, 255, 0.5),
                                splashRadius: 25,
                                onPressed: () {
                                  showMyDialog(
                                    context: context,
                                    title: 'Change name',
                                    content: 'Enter your new name',
                                    actions: [
                                      Column(
                                        children: [
                                          TextField(
                                            controller: changeNameController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              defaultButton(
                                                text: 'Change',
                                                isUpperCase: false,
                                                width: 100,
                                                background: Colors.red,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  cubit.changeName(
                                                      changeNameController
                                                          .text);
                                                  changeNameController.text =
                                                      "";
                                                },
                                              ),
                                              Spacer(),
                                              defaultButton(
                                                text: 'Cancel',
                                                isUpperCase: false,
                                                width: 100,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  changeNameController.text =
                                                      "";
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                      thickness: 2,
                      indent: 12,
                      endIndent: 12,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'Bio',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.start,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            iconSize: 30,
                            color: Theme.of(context).primaryColor,
                            splashColor: Color.fromRGBO(10, 199, 255, 0.5),
                            splashRadius: 25,
                            onPressed: () {
                              showMyDialog(
                                context: context,
                                title: 'Change bio',
                                content: '',
                                actions: [
                                  Column(
                                    children: [
                                      TextField(
                                        controller: changeNameController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          defaultButton(
                                            text: 'Change',
                                            isUpperCase: false,
                                            width: 100,
                                            background: Colors.red,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              cubit.changeName(
                                                  changeNameController.text);
                                              changeNameController.text = "";
                                            },
                                          ),
                                          Spacer(),
                                          defaultButton(
                                            text: 'Cancel',
                                            isUpperCase: false,
                                            width: 100,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              changeNameController.text = "";
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'i am jaskld askdlask aslkasdklajsd alksndaksdkla sknasd aksndka sds'
                        'askdnkas mas dk asl asdnaksda ',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
