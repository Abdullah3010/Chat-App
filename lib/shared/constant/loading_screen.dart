import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            ),
            Container(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
