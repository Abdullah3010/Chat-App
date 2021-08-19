import 'package:chat/layout/login.dart';
import 'package:chat/modules/chat/chat_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print(1);
  await LocalData.int();
  print(2);
  ID = LocalData.getString(key: 'uid') ?? 'null';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget widget = LoadingScreen();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ChatAppCubit()..getData(ID),
          ),
        ],
        child: BlocConsumer<ChatAppCubit, ChatAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetDataLoadingState) widget = LoadingScreen();

            if (state is GetDataErrorState) widget = ErrorScreen();

            if (state is GetDataSuccessState) widget = ChatScreen();

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  color: Colors.white,
                  titleSpacing: 20,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                ),
                scaffoldBackgroundColor: Colors.white,
                textTheme: TextTheme(
                  headline4: TextStyle(fontWeight: FontWeight.bold),
                  bodyText1: TextStyle(fontSize: 16),
                  bodyText2: TextStyle(fontSize: 16),
                ),
                primarySwatch: Colors.blue,
              ),
              home: ID.compareTo('null') != 0 ? widget : Login(),
            );
          },
        ));
  }
}
