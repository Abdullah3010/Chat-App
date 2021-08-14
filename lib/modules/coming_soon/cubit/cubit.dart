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

  int index = 1;
  List<String> errorMessage = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  void validateOne(String value) {
    emit(ValidateOneLoadingState());
    if (value.isEmpty) {
      errorMessage[0] = '🤨🤨هنستعبط من اولها';
      emit(ValidateOneErrorState());
    } else if (value.compareTo('تمام') == 0 ||
        value.compareTo('فله') == 0 ||
        value.compareTo('اشطا') == 0) {
      errorMessage[0] = '🙄🙄اسمها الحمد لله';
      emit(ValidateOneErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('one')
          .set({'answer': value}).then((value) {
        index++;
        emit(ValidateOneSuccessState());
      }).catchError((error) {
        emit(ValidateOneErrorState());
      });
    }
  }

  void validateTwo() {
    index++;
    emit(ValidateTwoSuccessState());
  }

  void validateThree(String value) {
    emit(ValidateThreeLoadingState());
    if (value.isEmpty) {
      errorMessage[2] = '🙂🙂هنستعبط تاني';
      emit(ValidateThreeErrorState());
    } else if (value.compareTo('لا') == 0 ||
        value.compareTo('مش عايزه') == 0 ||
        value.compareTo('نو') == 0) {
      errorMessage[2] = '🥴🥴🥴نينينينيني طز فيكي';
      emit(ValidateThreeErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('three')
          .set({'answer': value}).then((value) {
        emit(ValidateThreeSuccessState());
      }).catchError((error) {
        emit(ValidateThreeErrorState());
      });
    }
  }

  void validateThreeDone() {
    index++;
    emit(ValidateThreeDoneState());
  }

  void validateFour(String value) {
    emit(ValidateFourLoadingState());
    if (value.isEmpty) {
      errorMessage[3] = '😡😡هنستعبط تاني بقي الله';
      emit(ValidateFourErrorState());
    } else if (value.compareTo('لا') == 0 ||
        value.compareTo('مش عايزه') == 0 ||
        value.compareTo('نو') == 0) {
      errorMessage[3] = '🥺🥺يوووووووووه ';
      emit(ValidateFourErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('four')
          .set({'answer': value}).then((value) {
        index++;
        emit(ValidateFourSuccessState());
      }).catchError((error) {
        emit(ValidateFourErrorState());
      });
    }
  }

  void validateFive(String value) {
    emit(ValidateFiveLoadingState());
    if (value.isEmpty) {
      errorMessage[4] = '🥺🥺استغفر الله انا غلطان يعني';
      emit(ValidateFiveErrorState());
    } else if (value.compareTo('لا') == 0 ||
        value.compareTo('مش عايزه') == 0 ||
        value.compareTo('مفيش') == 0 ||
        value.compareTo('نو') == 0) {
      errorMessage[4] = '😭😭😭حرااام والله';
      emit(ValidateFiveErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('five')
          .set({'answer': value}).then((value) {
        index++;
        emit(ValidateFiveSuccessState());
      }).catchError((error) {
        emit(ValidateFiveErrorState());
      });
    }
  }

  void validateSix(String value) {
    emit(ValidateSixLoadingState());
    if (value.isEmpty) {
      errorMessage[5] = 'المره الجيه هشتم🤬🤬🤬';
      emit(ValidateSixErrorState());
    } else if (value.compareTo('لا') == 0 ||
        value.compareTo('مش عايزه') == 0 ||
        value.compareTo('مفيش') == 0 ||
        value.compareTo('نو') == 0) {
      errorMessage[5] = 'والله حرااام تاااني ******🤬🤬🤬';
      emit(ValidateSixErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('six')
          .set({'answer': value}).then((value) {
        index++;
        emit(ValidateSixSuccessState());
      }).catchError((error) {
        emit(ValidateSixErrorState());
      });
    }
  }

  void validateSeven(String value) {
    emit(ValidateSevenLoadingState());
    if (value.isEmpty) {
      errorMessage[6] = '🤬🤬🤬🤬***************';
      emit(ValidateSevenErrorState());
    } else {
      FirebaseFirestore.instance
          .collection('nermeen')
          .doc('seven')
          .set({'answer': value}).then((value) {
        index++;
        emit(ValidateSevenSuccessState());
      }).catchError((error) {
        emit(ValidateSevenErrorState());
      });
    }
  }
}
