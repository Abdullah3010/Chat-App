import 'package:chat/models/friend_request.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/friends/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFriendCubit extends Cubit<AddFriendsStats> {
  AddFriendCubit() : super(AddFriendsInitialStats());

  static AddFriendCubit get(context) => BlocProvider.of(context);

  List<Unfriends> unfriendUsers = [];
  List<String> sentRequest = [];
  List<String> requests = [];
  String color = "";

  void getUnfriendUsers(
    List<QueryDocumentSnapshot<Object?>> users,
    List<QueryDocumentSnapshot<Object?>> sent,
    List<QueryDocumentSnapshot<Object?>> request,
  ) {
    unfriendUsers.clear();
    sentRequest.clear();

    sent.forEach((element) {
      sentRequest.add(element.id);
    });
    request.forEach((element) {
      requests.add(element.id);
    });

    print(sentRequest);
    print(requests);

    users.forEach((user) {
      int check = 0;
      if (user.id != ME.uId) {
        FRIENDS.forEach((friend) {
          if (user.id != friend.uId) {
            check++;
          }
        });
        if (check == FRIENDS.length &&
            !sentRequest.contains(user.id) &&
            !requests.contains(user.id))
          unfriendUsers.add(Unfriends(
            username: user['username'],
            uId: user.id,
            imageUrl: user['image_url'],
          ));
      }
    });
    emit(GetUnfriendsStats());
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

  void removeFriend(String? id, int index) {
    emit(RemoveFriendLoadingStats());
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .collection('sent_request')
        .doc('$id')
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('$id')
          .collection('friend_request')
          .doc('${ME.uId}')
          .delete()
          .catchError((error) {
        emit(RemoveFriendErrorStats());
      });
      sentIndex.remove(index);
      emit(RemoveFriendSuccessStats());
    }).catchError((error) {
      emit(RemoveFriendErrorStats());
    });
  }

  void acceptRequest(String uid, String username, String image) {
    emit(AcceptFriendLoadingStats());
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .collection('friend_request')
        .doc('$uid')
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('${ME.uId}')
          .collection('friends')
          .doc('$uid')
          .set({
        'image_url': image,
        'username': username,
        'last_message': "",
      }).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc('$uid')
            .collection('sent_request')
            .doc('${ME.uId}')
            .delete()
            .then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc('$uid')
              .collection('friends')
              .doc('${ME.uId}')
              .set({
            'image_url': ME.imageUrl,
            'username': ME.username,
            'last_message': "",
          }).then((value) {
            FirebaseFirestore.instance
                .collection('chat')
                .doc('${ME.uId}' + '$uid')
                .set({
              '${ME.uId}': '',
              '$uid': '',
              '${ME.uId}' + 'L': '',
              '$uid' + 'L': '',
              '${ME.uId}' + 'unread': 0,
              '$uid' + 'unread': 0,
            }).then((value) {
              emit(AcceptFriendSuccessStats());
            }).catchError((error) {
              emit(AcceptFriendErrorStats());
            });
          }).catchError((error) {
            emit(AcceptFriendErrorStats());
          });
        }).catchError((error) {
          emit(AcceptFriendErrorStats());
        });
      }).catchError((error) {
        emit(AcceptFriendErrorStats());
      });
    }).catchError((error) {
      emit(AcceptFriendErrorStats());
    });
  }

  void cancelRequest(String uid) {
    emit(AcceptFriendLoadingStats());
    FirebaseFirestore.instance
        .collection('users')
        .doc('${ME.uId}')
        .collection('friend_request')
        .doc('$uid')
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('$uid')
          .collection('sent_request')
          .doc('${ME.uId}')
          .delete()
          .then((value) {
        emit(AcceptFriendSuccessStats());
      }).catchError((error) {
        emit(AcceptFriendErrorStats());
      });
    }).catchError((error) {
      emit(AcceptFriendErrorStats());
    });
  }

  void changeColor(bool isEmpty) {
    if (!isEmpty)
      color = "red";
    else
      color = "";
    emit(ColorChangeStats());
  }
}
