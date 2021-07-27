class NewUser {
  String? username;
  String? email;
  String? password;
  String? imageUrl;
  String? uId;

  NewUser({
    this.username,
    this.email,
    this.password,
    this.imageUrl = 'null',
    this.uId,
  });

  NewUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'image_url': imageUrl,
    };
  }
}

class Friends {
  String? username;
  String? imageUrl;
  String? uId;
  String? lastMessage;
  String? state;

  Friends(
      {this.username,
      this.imageUrl = 'null',
      this.uId,
      this.lastMessage,
      this.state});

  Friends.fromJson(
    Map<String, dynamic> json,
    String uid,
  ) {
    username = json['username'];
    imageUrl = json['image_url'];
    lastMessage = json['last_message'];
    uId = uid;
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
