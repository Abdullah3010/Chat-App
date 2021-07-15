import 'package:bloc/bloc.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppCubit extends Cubit<ChatAppStates> {
  ChatAppCubit() : super(ChatAppInitialState());

  static ChatAppCubit get(context) => BlocProvider.of(context);
}
