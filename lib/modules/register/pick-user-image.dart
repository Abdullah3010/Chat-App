import 'package:chat/modules/chat/chat_screen.dart';
import 'package:chat/modules/register/cubit/cubit.dart';
import 'package:chat/modules/register/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickUserImage extends StatelessWidget {
  final String username;
  final String email;
  final String password;

  PickUserImage(
    this.username,
    this.email,
    this.password,
  );

  @override
  Widget build(BuildContext context) {
    late RegisterCubit cubit;
    Widget? imageWidget;
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
          create: (context) => RegisterCubit(),
          child: BlocConsumer<RegisterCubit, RegisterStates>(
            listener: (context, state) {
              if (state is ImageSelectionLoadingState)
                imageWidget = CircleAvatar(
                  radius: 130,
                  child: CircularProgressIndicator(),
                );

              if (state is ImageSelectionSuccessesState)
                imageWidget = CircleAvatar(
                  backgroundImage: FileImage(
                    cubit.image!,
                  ),
                  radius: 130,
                );

              if (state is ImageSelectionErrorState)
                showMyDialog(
                  context: context,
                  title: 'Sorry',
                  content: 'Some something wrong check your internet'
                      'and try again.',
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        defaultButton(
                          text: 'Ok',
                          background: Colors.red,
                          textColor: Colors.white,
                          width: 100,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                );

              if (state is LoginSuccessesState)
                navigateAndFinish(context, ChatScreen());
            },
            builder: (context, state) {
              cubit = RegisterCubit.get(context);
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 140,
                            child: cubit.image != null
                                ? imageWidget
                                : CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 130,
                                    child: Icon(
                                      Icons.person,
                                      size: 250,
                                    ),
                                  ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            width: 80,
                            child: InkWell(
                              child: CircleAvatar(
                                radius: 40,
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                ),
                              ),
                              onTap: () {
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
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      (state is LoginLoadingState)
                          ? Padding(
                              padding: const EdgeInsets.all(7),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : defaultButton(
                              text: 'sign in',
                              width: double.infinity,
                              onPressed: () {
                                cubit.register(
                                  username: username,
                                  email: email,
                                  password: password,
                                );
                              },
                            ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
