import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  String? uid;
  String? name;
  String? image;
  Timestamp? time;

  FriendRequest({
    this.uid,
    this.name,
    this.image,
    this.time,
  });

  FriendRequest.fromJason(
    Map<String, dynamic> json,
    String uid,
  ) {
    this.name = json['username'];
    this.image = json['image_url'];
    this.time = json['time'];
    this.uid = uid;
  }

  toMap() {
    return {
      'username': this.name,
      'image_url': this.image,
      'time': this.time,
    };
  }
}
