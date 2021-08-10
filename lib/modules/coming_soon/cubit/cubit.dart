import 'package:bloc/bloc.dart';
import 'package:chat/models/message.dart';
import 'package:chat/models/user.dart';
import 'package:chat/modules/chat/chats.dart';
import 'package:chat/modules/chat/cubit/states.dart';
import 'package:chat/modules/coming_soon/coming_soon_screen.dart';
import 'package:chat/modules/coming_soon/cubit/states.dart';
import 'package:chat/modules/friends/add_friend_screen.dart';
import 'package:chat/modules/profile/profile_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComingSoonCubit extends Cubit<ComingSoonStates> {
  ComingSoonCubit() : super(ComingSoonInitialState());

  static ComingSoonCubit get(context) => BlocProvider.of(context);
}
