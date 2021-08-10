import 'package:chat/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late String ID;

NewUser ME = NewUser();

List<Friends> FRIENDS = [];
enum userStates { ONLINE, OFFLINE }

Widget userData({
  required BuildContext context,
  required String image,
  required String username,
  String lastMessage = '',
  bool isOnline = false,
}) {
  return Row(
    children: [
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 40,
            child: CircleAvatar(
              radius: 37,
              backgroundImage: NetworkImage(
                image,
              ),
            ),
          ),
          if (isOnline)
            CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              radius: 13,
              child: CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 10,
              ),
            ),
        ],
      ),
      SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Container(
              width: 150,
              child: Text(
                lastMessage,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      )
    ],
  );
}
