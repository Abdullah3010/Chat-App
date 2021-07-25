import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? message;
  Timestamp? time;
  String? from;
  String? to;
  String? type;
  String? image;

  Message({
    this.message,
    this.time,
    this.from,
    this.to,
    this.type,
    this.image,
  });
  Map<String, dynamic> toMap() {
    return {
      'text': this.message,
      'from': this.from,
      'to': this.to,
      'type': this.type,
      'image_url': this.image,
      'time': this.time,
    };
  }
}
