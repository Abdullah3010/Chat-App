import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserChat extends StatelessWidget {
  final String receiverId;
  final ChatCubit cubit;

  UserChat(this.receiverId, this.cubit);

  @override
  Widget build(BuildContext context) {
    Widget? screen = LoadingScreen();
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatLoadState) screen = LoadingScreen();
          if (state is ChatErrorState) screen = ErrorScreen();
        },
        builder: (context, state) {
          if (state is ChatInitialState) {
            // cubit.getChatId(receiverId).then((value) {
            //   print('hhh1');
            //   print('12' + value);
            //   screen = StreamBuilder(
            //     stream: FirebaseFirestore.instance
            //         .collection('chat')
            //         .doc(value)
            //         .collection('messages')
            //         .snapshots(),
            //     builder: (
            //       context,
            //       AsyncSnapshot<QuerySnapshot> snapshot,
            //     ) {
            //       return ListView.separated(
            //         physics: BouncingScrollPhysics(),
            //         separatorBuilder: (context, index) => SizedBox(
            //           height: 7,
            //         ),
            //         itemBuilder: (context, index) {
            //           return buildMessage(
            //               context: context,
            //               isMe: true,
            //               message: snapshot.data!.docs[index]['text']);
            //         },
            //         itemCount: snapshot.data!.docs.length,
            //       );
            //     },
            //   );
            // });
          }

          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [Expanded(child: screen!), TextFormField()],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildMessage({
    required BuildContext context,
    required bool isMe,
    required String message,
  }) =>
      Align(
        alignment: isMe
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: isMe ? Radius.circular(0) : Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topLeft: !isMe ? Radius.circular(0) : Radius.circular(10),
            ),
            color: isMe ? Theme.of(context).primaryColor : Colors.grey,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: 16,
                ),
          ),
        ),
      );
}
