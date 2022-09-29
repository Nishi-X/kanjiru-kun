import 'package:flutter/material.dart';
import 'package:kanjurukun/Stampcard.dart';
import 'Top.dart';
import 'Quiz.dart';
import 'MyDict.dart';
import 'Stampcard.dart';
import 'Guruguru.dart';
import 'quiz_top.dart';
import 'quiz_word.dart';
import 'quiz_null.dart';
import 'quiz_answer.dart';
import 'Footer.dart';
import 'textpage.dart';

// DB用
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '漢字るクン',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansJP',
      ),
      home: Top(),
      //ページ遷移の管理

      routes: {
        "/Top": (BuildContext context) => Top(),
        //"/Reading": (BuildContext context) => Reading(),
        "/quiz_top": (BuildContext context) => quiz_top(),
        "/MyDict": (BuildContext context) => MyDict(),
        "/Stampcard": (BuildContext context) => Stampcard(),
        "/quiz_word": (BuildContext context) => quiz_word(),
        "/quiz_null": (BuildContext context) => quiz_null(),
        "/quiz_answer": (BuildContext context) => quiz_answer(),
        "/text": (BuildContext context) => TextPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/Guruguru") {
          return MaterialPageRoute(
              builder: (context) => Guruguru(image: settings.arguments));
        }
        return null;
      },
    );
  }
}
