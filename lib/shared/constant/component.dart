import 'package:flutter/material.dart';

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
  required String label,
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  TextInputType type = TextInputType.text,
  Widget? prefix,
  Widget? suffix,
  bool isPassword = false,
  Function? onSubmit,
  FocusNode? focusNode,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(),
        enabledBorder: UnderlineInputBorder(),
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
      validator: validator,
      onFieldSubmitted: (value) {
        if (onSubmit != null) onSubmit();
      },
      focusNode: focusNode,
    );

Widget defaultButton({
  String text = '',
  required Function onPressed,
  double width = double.infinity,
  Color background = Colors.blue,
  Color textColor = Colors.white,
  Color iconColor = Colors.white,
  bool isUpperCase = true,
  bool addIcon = false,
  double radius = 5,
  IconData? icon,
  double iconSize = 30,
  splashColor: Colors.grey,
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
                fontWeight: FontWeight.bold,
                fontSize: 22,
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
  MainAxisAlignment actionAliment = MainAxisAlignment.start,
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
        actionsPadding: EdgeInsets.zero,
        actions: [
          Row(
            mainAxisAlignment: actionAliment,
            children: actions,
          )
        ],
      ),
    );

Widget circleImage({
  required String image,
  double bigRadius = 35,
  double smallRadius = 33,
}) {
  return CircleAvatar(
    radius: bigRadius,
    child: CircleAvatar(
      radius: smallRadius,
      backgroundImage: NetworkImage(
        image,
      ),
    ),
  );
}

Widget userData({
  required BuildContext context,
  required String image,
  required String username,
  String lastMessage = '',
  bool isOnline = false,
}) {
  return Row(
    children: [
      Stack(
        alignment: Alignment.bottomRight,
        children: [
          circleImage(image: image),
          if (isOnline)
            CircleAvatar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              radius: 10,
              child: CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 7,
              ),
            ),
        ],
      ),
      SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            username,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Container(
              width: 150,
              child: Text(
                lastMessage,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      )
    ],
  );
}
