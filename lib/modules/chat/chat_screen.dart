import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/chat/user_chat.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = ChatCubit();
    String? receiverId;

    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatSuccessState)
            navigate(context, UserChat(receiverId!, cubit));
          print(receiverId);
        },
        builder: (context, state) {
          cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: cubit.screens[cubit.currentIndex],
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     FirebaseAuth.instance.signOut();
            //     LocalData.clear();
            //   },
            // ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                  ),
                  label: 'Add Friend',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                  ),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                  ),
                  label: 'Profile',
                ),
              ],
              showUnselectedLabels: true,
              elevation: 20,
              currentIndex: 1,
              iconSize: 40,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedIconTheme: IconThemeData(
                size: 28,
              ),
              onTap: (index) {
                cubit.changeScreen(index);
              },
            ),
          );
        },
      ),
    );
  }
}
