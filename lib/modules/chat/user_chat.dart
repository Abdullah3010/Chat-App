import 'package:chat/modules/chat/cubit/cubit.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
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
    print(111);
    TextEditingController textController = TextEditingController();
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              toolbarHeight: 70,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(left: 50, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    circleImage(
                      image: cubit.imageUrl,
                      bigRadius: 27,
                      smallRadius: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            cubit.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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
                                      .headline3!
                                      .copyWith(fontSize: 18),
                                  hintText: 'type a message ....',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
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
                            height: 50,
                            width: 50,
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
                                size: 22,
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
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: isMe ? Radius.circular(0) : Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: !isMe ? Radius.circular(0) : Radius.circular(10),
              ),
              color: isMe
                  ? Theme.of(context).primaryColor.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                message,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontSize: 16,
                    ),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
              ),
            ),
          ),
        ),
      );
}
