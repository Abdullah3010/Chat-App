import 'package:flutter/material.dart';

import 'image_view_screen.dart';

AppBar defaultAppBar({
  required String text,
  required BuildContext? context,
  List<Widget>? actions,
}) =>
    AppBar(
      title: Text(
        text,
      ),
      actions: actions,
      titleSpacing: 5.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context!);
        },
        icon: Icon(
          Icons.arrow_back_rounded,
        ),
      ),
    );

Widget defaultFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  TextInputType type = TextInputType.text,
  IconData? prefix,
  Widget? suffix,
  bool isPassword = false,
  Function? onSubmit,
  FocusNode? focusNode,
  int? maxLength,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      cursorHeight: 25,
      decoration: InputDecoration(
        counter: Offstage(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color.fromRGBO(226, 226, 226, 1.0)
              : Theme.of(context).primaryColor,
        ),
        suffixIcon: suffix,
      ),
      style: Theme.of(context).textTheme.headline5,
      validator: validator,
      onFieldSubmitted: (value) {
        if (onSubmit != null) onSubmit();
      },
      focusNode: focusNode,
      maxLength: maxLength,
    );

Widget defaultButton({
  String text = '',
  required Function onPressed,
  double width = double.infinity,
  Color background = Colors.purple,
  Color textColor = Colors.white,
  Color iconColor = Colors.white,
  bool isUpperCase = true,
  bool addIcon = false,
  double radius = 5,
  IconData? icon,
  double iconSize = 30,
  double textSize = 22,
  Color splashColor = Colors.grey,
  FontWeight fontWeight = FontWeight.bold,
}) =>
    Container(
      width: width,
      child: MaterialButton(
        splashColor: splashColor,
        padding: EdgeInsets.all(12),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (addIcon)
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            Text(
              isUpperCase ? text.toUpperCase() : text,
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: textSize,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

void navigate(context, screen) => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

void navigateAndFinish(context, screen) =>
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );

showMyDialog({
  required BuildContext context,
  required String title,
  required String content,
  required List<Widget> actions,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
          color: Colors.deepOrange,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        content: Container(
          child: Text(content),
          width: 400,
        ),
        elevation: 20,
        buttonPadding: EdgeInsets.all(20),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 27,
        ),
        actionsPadding: EdgeInsets.zero,
        actions: actions,
      ),
    );

Widget circleImage({
  required BuildContext context,
  required String image,
  double bigRadius = 35,
  double smallRadius = 33,
}) {
  return InkWell(
    child: CircleAvatar(
      radius: bigRadius,
      child: image != ""
          ? CircleAvatar(
              radius: smallRadius,
              backgroundImage: NetworkImage(
                image,
              ),
            )
          : CircleAvatar(
              backgroundColor:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).scaffoldBackgroundColor,
              radius: smallRadius,
              child: Icon(
                Icons.person,
                size: bigRadius,
              ),
            ),
    ),
    onTap: () {
      navigate(context, ImageViewScreen(url: image));
    },
  );
}
