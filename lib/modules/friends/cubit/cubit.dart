import 'package:chat/models/user.dart';
import 'package:chat/modules/friends/cubit/states.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFriendCubit extends Cubit<AddFriendsStats> {
  AddFriendCubit() : super(AddFriendsInitialStats());

  static AddFriendCubit get(context) => BlocProvider.of(context);

  List<Unfriends> unfriendUsers = [];

  void getUnfriendUsers(List<QueryDocumentSnapshot<Object?>> users) {
    unfriendUsers.clear();
    users.forEach((user) {
      int check = 0;
      FRIENDS.forEach((friend) {
        if (user.id != friend.uId) check++;
      });
      if (check == FRIENDS.length)
        unfriendUsers.add(Unfriends(
          username: user['username'],
          uId: user.id,
          imageUrl: user['image_url'],
        ));
    });
  }
}
