import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser {
  String? username;
  String? email;
  String? password;
  String? imageUrl;
  String? uId;
  String? state;
  Timestamp? lastSeen;

  NewUser(
      {this.username,
      this.email,
      this.password,
      this.imageUrl = 'null',
      this.uId,
      this.state,
      this.lastSeen});

  NewUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    imageUrl = json['image_url'];
    state = json['state'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'image_url': imageUrl,
      'state': state,
      'last_seen': lastSeen,
    };
  }
}

class Friends {
  String? username;
  String? imageUrl;
  String? uId;
  String? lastMessage;
  String? state;
  String? chatID;
  Timestamp? lastSeen;

  Friends(
      {this.username,
      this.imageUrl = 'null',
      this.uId,
      this.lastMessage,
      this.state,
      this.lastSeen,
      this.chatID});

  Friends.fromJson(
    Map<String, dynamic> json,
    String uid,
    String lastmessage,
  ) {
    username = json['username'];
    imageUrl = json['image_url'];
    state = json['state'];
    uId = uid;
    lastMessage = lastmessage;
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'image_url': imageUrl,
      'state': state,
      'uid': uId
    };
  }
}

class Unfriends {
  String? username;
  String? imageUrl;
  String? uId;

  Unfriends({
    this.username,
    this.imageUrl = 'null',
    this.uId,
  });

  Unfriends.fromJson(
    Map<String, dynamic> json,
    String uid,
  ) {
    username = json['username'];
    imageUrl = json['image_url'];
    uId = uid;
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'image_url': imageUrl, 'uid': uId};
  }
}
