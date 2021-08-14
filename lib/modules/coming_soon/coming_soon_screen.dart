import 'dart:ui';

import 'package:chat/modules/coming_soon/cubit/cubit.dart';
import 'package:chat/modules/coming_soon/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:chat/shared/constant/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController one = TextEditingController();
    TextEditingController two = TextEditingController();
    TextEditingController three = TextEditingController();
    TextEditingController four = TextEditingController();
    TextEditingController five = TextEditingController();
    TextEditingController six = TextEditingController();
    TextEditingController seven = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextStyle textStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: Image.asset(
                'lib/img/flower.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('nermeen')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingScreen();

                      return (snapshot.data!.docs[2]['show'])
                          ? Center(
                              child: Text(
                                'مقلنا كمنج سووون الله🤨🤨',
                                style: textStyle,
                              ),
                            )
                          : BlocProvider(
                              create: (context) => ComingSoonCubit(),
                              child: BlocConsumer<ComingSoonCubit,
                                  ComingSoonStates>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  ComingSoonCubit cubit =
                                      ComingSoonCubit.get(context);
                                  print(cubit.index);

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (cubit.index == 1)
                                        Text(
                                          'النهرده عيد ميلادك او مش النهرده اووي'
                                          ' هبعتهولك بدري قبل الزحمه بقي😂😂😂😂😂😂\n'
                                          'انا قلت ايه بقي الواحد يعمل حاجه كريتڤ كده اعمل ايه'
                                          ' ياض ياعبدالله🤔🤔'
                                          '\n'
                                          ' قلت احتفل هنا لا سلكي ونلعب كده ونهزر\n'
                                          '\n🌚🌚🌚وانتي عامله ايه؟'
                                          '\n${cubit.errorMessage[0]}',
                                          textAlign: TextAlign.end,
                                          style: textStyle,
                                        ),
                                      if (cubit.index == 1)
                                        TextFormField(
                                          controller: one,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: '....جاوبي عدل',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 1)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 1)
                                        (state is ValidateOneLoadingState)
                                            ? loading()
                                            : defaultButton(
                                                text: 'اللي بعده',
                                                width: 150,
                                                onPressed: () {
                                                  cubit.validateOne(one.text);
                                                },
                                                background: state
                                                        is ValidateOneErrorState
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      if (cubit.index == 2)
                                        Text(
                                          '\nطب لو عندك بيضه اومليت وحبيتي'
                                          ' ترجعيها مسلوقه تعملي ايه ؟'
                                          '\n'
                                          '😂😂😂😂',
                                          textAlign: TextAlign.end,
                                          style: textStyle,
                                        ),
                                      if (cubit.index == 2)
                                        TextFormField(
                                          controller: two,
                                          enabled: false,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: '😂😂😂😂خلاص خلاص ',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 2)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 2)
                                        defaultButton(
                                          text: 'مااااشي',
                                          width: 150,
                                          onPressed: () {
                                            cubit.validateTwo();
                                          },
                                        ),
                                      if (cubit.index == 3)
                                        Text(
                                          '\n لو حابه تسألي سؤال؟'
                                          '(وانا هجاوب عليكي '
                                          'لان البرنامج جامد جوميده😎😎😎😎😎'
                                          ' بس اصبري عقبال ما ارد😂😂😂😂)'
                                          '\n${cubit.errorMessage[2]}',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      if (cubit.index == 3)
                                        TextFormField(
                                          controller: three,
                                          minLines: 2,
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'اتفضلي',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 3)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 3)
                                        (state is ValidateThreeLoadingState)
                                            ? loading()
                                            : (snapshot.data!.docs[2]
                                                        ['answer'] ==
                                                    "")
                                                ? defaultButton(
                                                    text: 'جاوب',
                                                    width: 150,
                                                    background: state
                                                            is ValidateThreeErrorState
                                                        ? Colors.red
                                                        : Colors.blue,
                                                    onPressed: () {
                                                      cubit.validateThree(
                                                          three.text);
                                                    },
                                                  )
                                                : defaultButton(
                                                    text: 'تمام',
                                                    width: 150,
                                                    onPressed: () {
                                                      cubit.validateThreeDone();
                                                    },
                                                  ),
                                      if (cubit.index == 3)
                                        Text(
                                          snapshot.data!.docs[2]['answer'],
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      if (cubit.index == 4)
                                        Text(
                                          '\n لو قدامك انك تطلبي مني طلب هيبقي ايه هو؟'
                                          '\n${cubit.errorMessage[3]}',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      if (cubit.index == 4)
                                        TextFormField(
                                          controller: four,
                                          minLines: 2,
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'اي طلب',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 4)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 4)
                                        (state is ValidateFourLoadingState)
                                            ? loading()
                                            : defaultButton(
                                                text: 'اللي بعده',
                                                width: 150,
                                                onPressed: () {
                                                  cubit.validateFour(four.text);
                                                },
                                                background: state
                                                        is ValidateFourErrorState
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      if (cubit.index == 5)
                                        Text(
                                          '\n انصحيني نصيحه جامده جوميده؟'
                                          '\n${cubit.errorMessage[4]}',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      if (cubit.index == 5)
                                        TextFormField(
                                          controller: five,
                                          minLines: 2,
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'انصحيييي',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 5)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 5)
                                        (state is ValidateFiveLoadingState)
                                            ? loading()
                                            : defaultButton(
                                                text: 'اللي بعده',
                                                width: 150,
                                                onPressed: () {
                                                  cubit.validateFive(five.text);
                                                },
                                                background: state
                                                        is ValidateFiveErrorState
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      if (cubit.index == 6)
                                        Text(
                                          '\n لو حابه توجهيلي رساله؟'
                                          '\n${cubit.errorMessage[5]}',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      if (cubit.index == 6)
                                        TextFormField(
                                          controller: six,
                                          minLines: 2,
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'خودي راحتك',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 6)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 6)
                                        (state is ValidateSixLoadingState)
                                            ? loading()
                                            : defaultButton(
                                                text: 'بس كده',
                                                width: 150,
                                                onPressed: () {
                                                  cubit.validateSix(six.text);
                                                },
                                                background: state
                                                        is ValidateSixErrorState
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      if (cubit.index == 7)
                                        Text(
                                          '\n تقيمك؟'
                                          '\n${cubit.errorMessage[6]}',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      if (cubit.index == 7)
                                        TextFormField(
                                          controller: seven,
                                          minLines: 2,
                                          maxLines: 5,
                                          textAlign: TextAlign.end,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'قيمي عدددل',
                                            focusColor:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      if (cubit.index == 7)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (cubit.index == 7)
                                        (state is ValidateSevenLoadingState)
                                            ? loading()
                                            : defaultButton(
                                                text: 'قيمت',
                                                width: 150,
                                                onPressed: () {
                                                  cubit.validateSeven(
                                                      seven.text);
                                                },
                                                background: state
                                                        is ValidateSevenErrorState
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      if (cubit.index == 8)
                                        Text(
                                          '\nنتكلم جد اووي اووي جدا خالص'
                                          '\n'
                                          '😂😂😂'
                                          '\n'
                                          '\n كنت عايز اقولك كل سنه'
                                          ' وانتي طيبه وفي سعاده دايما وعظمه مستمره من كل الجهات'
                                          ' وربنا يثبتك ويحفظك ويوفقك لكل اللى فيه الخير ليكي و يكرمك وربنا '
                                          'يبعد الحزن عنك وتفضلي مبسوطه دايما كده'
                                          '\n وعايز اشكرك'
                                          ' لانك في حياتي عموما ولأنك ساعدتيني في حاجات كتير'
                                          'اووى وانتي مش واخده بالك كمان وعايز اقولك'
                                          ' اوعي تتغيري مهما حصل انتي حلوه كده'
                                          '\n'
                                          '🥳🥳🥳🥳🥳🎉🎉🎉🎉❤❤❤❤❤❤❤❤❤❤❤❤❤❤'
                                          '\nوبس انا زهقت كفايه عليكي كده صدعتيني'
                                          '\n'
                                          ' 😒😒😒😒😒',
                                          textAlign: TextAlign.end,
                                          style: textStyle,
                                        ),
                                      if (cubit.index == 8)
                                        Text(
                                          'وبس كده ياستي هي دي المفجأه'
                                          ' يلا Happy birthday Nermeen'
                                          '\n'
                                          '🥳🥳🥳🥳🥳🎉🎉🎉🎉❤❤❤❤❤❤❤❤❤❤❤❤❤❤',
                                          style: textStyle,
                                          textAlign: TextAlign.end,
                                        ),
                                      SizedBox(
                                        height: 40,
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: Image.asset(
                'lib/img/flower.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget loading() {
  return Container(
    width: 150,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
