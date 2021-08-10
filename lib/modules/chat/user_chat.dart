import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserChat extends StatelessWidget {
  final String receiverId;
  final ChatCubit cubit;

  UserChat(this.receiverId, this.cubit);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .doc(cubit.chatId)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) return ErrorScreen();
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return LoadingScreen();
                        return ListView.separated(
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 7,
                          ),
                          itemBuilder: (context, index) {
                            return buildMessage(
                                context: context,
                                isMe: snapshot.data!.docs[index]['from'] ==
                                    ME.uId,
                                message: snapshot.data!.docs[index]['text']);
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: TextFormField(
                                controller: textController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black12,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 18,
                                    ),
                                decoration: InputDecoration(
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 18),
                                  hintText: 'type a message ....',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            height: 60,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            height: 60,
                            width: 60,
                            child: MaterialButton(
                              onPressed: () {
                                cubit.sendMessage(
                                  message: textController.text,
                                  to: receiverId,
                                );
                                textController.text = '';
                              },
                              child: Icon(
                                Icons.send,
                                size: 34,
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
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
