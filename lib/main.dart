import 'package:chat/layout/login.dart';
import 'package:chat/modules/chat/chat_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/constant/error_screen.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalData.int();
  ID = LocalData.getString(key: 'uid') ?? 'null';
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    FirebaseFirestore.instance.collection('chat').get().then((value) {
      CHATS = value.docs;
    });
    if (ID.compareTo('null') != 0) {
      setOnline().then((value) => print('online')).catchError((error) {
        print(error);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (ID.compareTo('null') != 0) {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          await setOffline();
          break;
        case AppLifecycleState.resumed:
        case AppLifecycleState.inactive:
          await setOnline();
          break;
      }
    }
  }

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
                  headline3: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                  headline6: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  headline5: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  headline4: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  bodyText1: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  bodyText2: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                //primarySwatch: Colors.blue,
                primarySwatch: Colors.purple,
                accentColor: Colors.purpleAccent,
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(),
                ),
              ),
              darkTheme: ThemeData(
                appBarTheme: AppBarTheme(
                  color: Color.fromRGBO(40, 40, 40, 1.0),
                  titleSpacing: 20,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  actionsIconTheme: IconThemeData(color: Colors.black),
                ),
                scaffoldBackgroundColor: Color.fromRGBO(40, 40, 40, 1.0),
                textTheme: TextTheme(
                  headline3: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                    fontSize: 24,
                  ),
                  headline6: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                    fontSize: 14,
                  ),
                  headline5: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                    fontSize: 18,
                  ),
                  headline4: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                    fontSize: 20,
                  ),
                  bodyText1: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                  ),
                  bodyText2: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                  ),
                ),
                primarySwatch: Colors.purple,
                accentColor: Colors.purpleAccent,
                iconTheme: IconThemeData(
                  color: Color.fromRGBO(226, 226, 226, 1.0),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(),
                  disabledBorder: OutlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(226, 226, 226, 1.0),
                  ),
                ),
              ),
              themeMode: ThemeMode.system,
              home: ID.compareTo('null') != 0 ? widget : Login(),
            );
          },
        ));
  }

  Future<void> setOnline() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$ID')
        .update({'state': 'Online'});
  }

  Future<void> setOffline() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('$ID')
        .update({'state': 'Offline', 'last_seen': Timestamp.now()});
  }
}
