import 'package:chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String ID = "";
List<QueryDocumentSnapshot<Map<String, dynamic>>> CHATS = [];
NewUser ME = NewUser();

List<Friends> FRIENDS = [];
