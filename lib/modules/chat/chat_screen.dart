import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/chat/user_chat.dart';
import 'package:chat/shared/constant/component.dart';
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
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_add_alt_1,
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
                    Icons.person_pin_rounded,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                  ),
                  label: 'Settings',
                ),
              ],
              showUnselectedLabels: true,
              elevation: 5,
              currentIndex: cubit.currentIndex,
              iconSize: 30,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedIconTheme: IconThemeData(
                size: 24,
              ),
              onTap: (index) {
                cubit.changeScreen(index);
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              type: BottomNavigationBarType.fixed,
            ),
          );
        },
      ),
    );
  }
}
