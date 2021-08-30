import 'package:chat/layout/login.dart';
import 'package:chat/models/user.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/network/local/local-db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          defaultButton(
            width: 90,
            text: 'Log out',
            textSize: 14,
            splashColor: Colors.red.withOpacity(0.1),
            fontWeight: FontWeight.w300,
            textColor: Colors.red,
            background: Colors.blue.withOpacity(0),
            onPressed: () {
              showMyDialog(
                context: context,
                title: 'Are you sure',
                content: 'you want to log out?',
                actions: [
                  defaultButton(
                    text: 'Yes',
                    isUpperCase: false,
                    width: 100,
                    background: Colors.red,
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        LocalData.removeData(key: 'uid');
                        ID = '';
                        ME = NewUser();
                        FRIENDS.clear();
                        Navigator.of(context).pop();
                        navigateAndFinish(context, Login());
                      }).catchError((error) {});
                      print(11);
                    },
                  ),
                  Spacer(),
                  defaultButton(
                    text: 'No',
                    isUpperCase: false,
                    width: 100,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('dfsf'),
      ),
    );
  }
}
