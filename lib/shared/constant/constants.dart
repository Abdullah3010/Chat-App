import 'package:chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late String ID;
late List<QueryDocumentSnapshot<Map<String, dynamic>>> CHATS;
NewUser ME = NewUser();

List<Friends> FRIENDS = [];
enum userStates { ONLINE, OFFLINE }
