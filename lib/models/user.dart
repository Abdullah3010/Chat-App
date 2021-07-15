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
    imageUrl = json['imageUrl'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
}
