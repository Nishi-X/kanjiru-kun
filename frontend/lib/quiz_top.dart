import 'package:flutter/material.dart';
import 'Footer.dart';
import 'KanjiData.dart';
//import 'quiz_answer.dart';

class quiz_top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; //画面サイズを取得
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "クイズTOP",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromRGBO(253, 213, 53, 1)),
      body: Column(children: [
        Container(
            height: size.height * 0.60, //ホームに戻るボタンによって変化
            alignment: Alignment.center,
            // ignore: prefer_const_constructors
            child: Text('出てくる漢字の\n読みを入力してね!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color.fromRGBO(253, 213, 53, 1),
            fixedSize: Size(
              size.width * 0.7,
              size.height * 0.05,
            ),
          ),
          child: const Text('クイズスタート!'),
          onPressed: () async {
            if ((await KanjiData.read_random()).isEmpty) {
              Navigator.pushNamed(context, '/quiz_null');
            } else {
              Navigator.pushNamed(context, '/quiz_word');
            }
          }, //ボタンを押した時の処理はここ
        )
      ]),
      bottomNavigationBar: const Footer(),
    );
  }
}
