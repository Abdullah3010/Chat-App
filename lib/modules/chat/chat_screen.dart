import 'package:chat/modules/chat/user_chat.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('${ME.uId}')
              .collection('friends')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return ErrorScreen();
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingScreen();

            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return InkWell(
                  child: userData(
                    context: context,
                    image: snapshot.data!.docs[index]['image_url'],
                    username: snapshot.data!.docs[index]['username'],
                    lastMessage: snapshot.data!.docs[index]['last_message'],
                  ),
                  onTap: () {
                    navigate(context, UserChat(snapshot.data!.docs[index].id));
                  },
                );
              },
              itemCount: snapshot.data!.size,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          LocalData.clear();
        },
      ),
    );
  }

  Widget userData({
    required BuildContext context,
    required String image,
    required String username,
    required String lastMessage,
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
}

// Row(
// children: [
// Stack(
// alignment: Alignment.bottomRight,
// children: [
// CircleAvatar(
// radius: 40,
// child: CircleAvatar(
// radius: 37,
// backgroundImage: NetworkImage(
// snapshot.data!.docs[index]['image_url'],
// ),
// ),
// ),
// if (snapshot.data!.docs[index]['state'].toLowerCase() ==
// 'online')
// CircleAvatar(
// backgroundColor:
// Theme.of(context).scaffoldBackgroundColor,
// radius: 13,
// child: CircleAvatar(
// backgroundColor: Colors.greenAccent,
// radius: 10,
// ),
// ),
// ],
// ),
// SizedBox(
// width: 10,
// ),
// Column(
// children: [
// Text(
// snapshot.data!.docs[index]['username'],
// style: Theme.of(context)
// .textTheme
//     .headline5!
// .copyWith(fontWeight: FontWeight.bold),
// ),
// SizedBox(
// height: 5,
// ),
// Text(
// snapshot.data!.docs[index]['username'],
// style: Theme.of(context).textTheme.headline6,
// )
// ],
// )
// ],
// );
