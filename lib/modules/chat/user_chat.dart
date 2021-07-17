import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserChat extends StatelessWidget {
  final String receiverId;

  UserChat(this.receiverId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(
                  height: 7,
                ),
                itemBuilder: (context, index) {
                  if (index % 2 == 0)
                    return buildMessage(
                      context: context,
                      isMe: true,
                      message:
                          'My name is fuck off your mother fucker yeeess nooo is my name',
                    );
                  else
                    return buildMessage(
                      context: context,
                      isMe: false,
                      message: 'messdhdfghdfghfghdfghdfghdfghdfghdfghage',
                    );
                },
                itemCount: 100,
              ),
            ),
            TextFormField()
          ],
        ),
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
            color: isMe
                ? Theme.of(context).primaryColor
                : Color.fromRGBO(226, 226, 226, 1.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 18,
                ),
          ),
        ),
      );
}
