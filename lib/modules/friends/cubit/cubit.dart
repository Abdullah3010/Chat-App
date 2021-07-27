import 'package:chat/models/friend_request.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/friends/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFriendCubit extends Cubit<AddFriendsStats> {
  AddFriendCubit() : super(AddFriendsInitialStats());

  static AddFriendCubit get(context) => BlocProvider.of(context);

  List<Unfriends> unfriendUsers = [];
  List<String> sentRequest = [];

  void getUnfriendUsers(
    List<QueryDocumentSnapshot<Object?>> users,
    List<QueryDocumentSnapshot<Object?>> sent,
  ) {
    unfriendUsers.clear();
    sentRequest.clear();

    sent.forEach((element) {
      sentRequest.add(element.id);
    });

    users.forEach((user) {
      int check = 0;
      if (user.id != ME.uId)
        FRIENDS.forEach((friend) {
          if (user.id != friend.uId && !sentRequest.contains(user.id)) check++;
        });

      if (check == FRIENDS.length)
        unfriendUsers.add(Unfriends(
          username: user['username'],
          uId: user.id,
          imageUrl: user['image_url'],
        ));
    });
    print(sentRequest);
  }

  List<int> sentIndex = [];

  void sendFriendRequest({
    required String to,
    required String name,
    required String image,
    required int index,
  }) {
    sentIndex.add(index);
    emit(SendRequestLoadingStats());
    FriendRequest toUser = FriendRequest(
      name: name,
      image: image,
      time: Timestamp.now(),
    );
    FriendRequest fromUser = FriendRequest(
      name: ME.username,
      image: ME.imageUrl,
      time: Timestamp.now(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc('$to')
        .collection('friend_request')
        .doc('${ME.uId}')
        .set(fromUser.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('${ME.uId}')
          .collection('sent_request')
          .doc('$to')
          .set(toUser.toMap())
          .then((value) {
        emit(SendRequestSuccessStats());
      }).catchError((error) {
        emit(SendRequestErrorStats());
      });
    }).catchError((error) {
      emit(SendRequestErrorStats());
    });
  }
}
