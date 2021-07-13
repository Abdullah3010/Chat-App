import 'package:chat/layout/login.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/register/pick-user-image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatAppCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
            ),
            titleSpacing: 10,
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
        home: PickUserImage(),
      ),
    );
  }
}
