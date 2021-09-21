import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 105,
              backgroundColor: Colors.deepOrange,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                  size: 150,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Some thing wrong',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Please check you internet connection and try again')
          ],
        ),
      )),
    );
  }
}
