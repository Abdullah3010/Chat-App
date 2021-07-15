import 'package:chat/modules/register/cubit/cubit.dart';
import 'package:chat/modules/register/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickUserImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? url = 'https://firebasestorage.googleapis.com/'
        'v0/b/test-project-eeb99.appspot.com/o/user_image%2Ftest%'
        '2Fimage_picker127597264248855870.jpg'
        '?alt=media&token=7e20acfe-a7c7-489e-991b-f8340faa7008';
    late RegisterCubit cubit;

    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
          create: (context) => RegisterCubit(),
          child: BlocConsumer<RegisterCubit, RegisterStates>(
            listener: (context, state) {
              if (state is ImageSelectionErrorState)
                print('ImageSelectionErrorState');
              if (state is ImageSelectionSuccessesState)
                print('ImageSelectionSuccessesState');

              if (state is ImageSelectionErrorState)
                showMyDialog(
                  context: context,
                  title: 'Sorry',
                  content: 'Some something wrong check your internet'
                      'and try again.',
                  actions: [
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
                );
            },
            builder: (context, state) {
              print(state is ImageSelectionSuccessesState);
              cubit = RegisterCubit();
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
                            child: url != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      cubit.imageUrl!,
                                    ),
                                    radius: 130,
                                  )
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
                                // showMyDialog(
                                //   context: context,
                                //   title: 'Select image',
                                //   content: 'Do you want to select from gallery '
                                //       'or tack a new one from camera',
                                //   actions: [
                                //     defaultButton(
                                //       text: 'Gallery',
                                //       isUpperCase: false,
                                //       addIcon: true,
                                //       icon: Icons.image_outlined,
                                //       width: 150,
                                //       onPressed: () {
                                //         Navigator.pop(context);
                                //         cubit.getImageFromGallery();
                                //       },
                                //     ),
                                //     Spacer(),
                                //     defaultButton(
                                //       text: 'Camera',
                                //       isUpperCase: false,
                                //       addIcon: true,
                                //       icon: Icons.camera_alt_outlined,
                                //       width: 150,
                                //       onPressed: () {
                                //         //cubit.getImageFromCamera();
                                //       },
                                //     ),
                                //   ],
                                // );
                                cubit.getImageFromGallery();
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      if (state is ImageSelectionLoadingState)
                        Padding(
                          padding: const EdgeInsets.all(7),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (state is! ImageSelectionLoadingState)
                        defaultButton(
                          text: 'sign in',
                          width: double.infinity,
                          onPressed: () {},
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
