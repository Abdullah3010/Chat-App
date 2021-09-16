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
import 'package:intl/intl.dart';

class UserChat extends StatefulWidget {
  final String receiverId;
  final ChatCubit cubit;

  UserChat(this.receiverId, this.cubit);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.cubit.chatId)
        .update({
      '${ME.uId}' + 'L': 'inside',
      '${ME.uId}' + 'unread': 0,
    });
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.cubit.chatId)
        .update({'${ME.uId}' + 'L': 'outside'});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      context: context,
                      image: widget.cubit.imageUrl,
                      bigRadius: 27,
                      smallRadius: 25,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cubit.username,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('chat')
                                .doc(widget.cubit.chatId)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError ||
                                  (snapshot.connectionState ==
                                      ConnectionState.waiting))
                                return Text(
                                  widget.cubit.isOnline ? 'Online' : 'Offline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 16),
                                );
                              if (snapshot.data!['${widget.receiverId}'] != "")
                                return Text(
                                  snapshot.data!['${widget.receiverId}'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 16),
                                );
                              else
                                return Text(
                                  widget.cubit.isOnline
                                      ? 'Online'
                                      : widget.cubit.lastSeen,
                                  style: Theme.of(context).textTheme.headline6!,
                                );
                            },
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
                          .doc(widget.cubit.chatId)
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
                              isMe:
                                  snapshot.data!.docs[index]['from'] == ME.uId,
                              message: snapshot.data!.docs[index]['text'],
                              time: snapshot.data!.docs[index]['time'],
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      },
                    ),
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
                                      .headline5!
                                      .copyWith(fontWeight: FontWeight.w300),
                                  hintText: 'type a message ....',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1)
                                    widget.cubit.setTyping();
                                  else if (value.isEmpty)
                                    widget.cubit.removeTyping();
                                },
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
                                if (textController.text.isNotEmpty) {
                                  widget.cubit.sendMessage(
                                    message: textController.text,
                                    to: widget.receiverId,
                                  );
                                  textController.text = '';
                                }
                                widget.cubit.removeTyping();
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
    required Timestamp time,
  }) =>
      Align(
        alignment: isMe
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 250,
            minHeight: 10,
            minWidth: 90,
          ),
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
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 18),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1!,
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: 80,
                  child: Text(
                    DateFormat('hh:mm a').format(time.toDate()),
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
