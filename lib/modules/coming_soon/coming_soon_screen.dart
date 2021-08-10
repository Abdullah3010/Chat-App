import 'package:chat/modules/coming_soon/cubit/cubit.dart';
import 'package:chat/modules/coming_soon/cubit/states.dart';
import 'package:chat/shared/constant/component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComingSoon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController first = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ha',
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
              color: Colors.red,
              height: double.infinity,
              child: Text('dd'),
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
                          .collection('collectionPath')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return BlocProvider(
                          create: (context) => ComingSoonCubit(),
                          child:
                              BlocConsumer<ComingSoonCubit, ComingSoonStates>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // Text(
                                    //   'النهرده عيد ميلادك او مش النهرده اووي'
                                    //   ' هبعتهولك بدري قبل الزحمه بقي (ايموجي بيضحك علشان مش عارف اعمله)'
                                    //   'انا قلت ايه بقي الواحد يعمل حاجه كريتڤ كده اعمل ايه'
                                    //   ' ياض ياعبدالله قلت احتفل هنا لا سلكي ونلعب كده ونهزر',
                                    //   textAlign: TextAlign.end,
                                    // ),
                                    // Text('وانتي عامله ايه؟'),
                                    TextFormField(
                                      controller: first,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          print('هنستعبط من اولها');
                                        } else if (value
                                                .compareTo('الحمد لله') ==
                                            0) {
                                          print('طب الحمد لله');
                                        } else if (value.compareTo('تمام') ==
                                            0) {
                                          print('اسمها الحمد لله');
                                        } else if (value.compareTo('فله') ==
                                            0) {
                                          print('طب الحمد لله');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.yellow,
              height: double.infinity,
              child: Text('lll'),
            ),
          ),
        ],
      ),
    );
  }
}

/*
*
* return Center(
      child: Text('مقولنا كمنج سوووون الله'),
    );
*
*/

/*
* النهرده عيد ميلادك او مش النهرده اووي هبعتهولك بدري قبل الزحمه بقي (ايموجي بيضحك علشان مش عارف اعمله)
انا قلت ايه بقي الواحد يعمل حاجه كريتڤ كده اعمل ايه ياض ياعبدالله قلت احتفل هنا لا سلكي
ونلعب كده ونهزر
انتي عامله ايه ؟
طب الحمد لله
لو خيروكي بيني وبيني تختاري مين ؟(نيهاهاها)
طب لو عندك بيضه اومليت وحبيتي ترجعيها مسلوقه تعملي ايه ؟
لا لا خلاص بجد نتكلم جد اووي اووي جدا خالص
"كنت عايز اقولك كل سنه وانتي طيبه وفي سعاده دايما وعظمه مستمره من كل الجهات وربنا يثبتك ويوفقك لكل اللى فيه الخير و يكرمك وربنا يبعد الحزن عنك وتفضلي مبسوطه دايما كده وعايز اشكرك لانك في حياتي عموما ولأنك ساعدتيني في حاجات كتير اووى وانتي مش واخده بالك كمان وعايز اقولك اوعي تتغيري انتي حلوه كده (ايموجي الاحتفال والرقص كتير وقلووب اكتر بقي )"
وبس انا زهقت كفايه عليكي كده
لو عايزه توجهيلي رساله
وبس كده ياستي هي دي المفجأه
يلا Happy birthday Nermeen
* */
