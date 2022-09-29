import 'package:flutter/material.dart';
import 'package:kanjurukun/quiz_word.dart';
import 'Footer.dart';

class quiz_answer extends StatefulWidget {
  quiz_answer({Key? key}) : super(key: key);
  State<quiz_answer> createState() => _quiz_answer();
}

class _quiz_answer extends State<quiz_answer> {
  String input_text="",word="",yomi="",imi="";
  late Color result_color = Colors.black;
  late String result_answer = "";

  // @override
  // void initState(){
  //   super.initState();
  //   result_color = Colors.black;
  //   result_answer = "";
  // }


  void judgment(BuildContext context) {
    View_dic args = ModalRoute.of(context)!.settings.arguments as View_dic;
    input_text = args.input_text; word = args.word; yomi = args.yomi; imi = args.imi;
    setState(() {
    if (input_text == yomi) {
      result_color = Colors.red;
      result_answer = "〇正解〇";
    }
    else {
      result_color = Colors.blue;
      result_answer = "×不正解×";
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    judgment(context);//正誤判定
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "解説",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromRGBO(253, 213, 53, 1)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top:size.height * 0.03),
                height: size.height * 0.09, //ホームに戻るボタンによって変化
                alignment: Alignment.topCenter,
                child: Text(result_answer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold, color: result_color))),
            Container(
                padding: EdgeInsets.only(top:size.height * 0.03),
                height: size.height * 0.09, //ホームに戻るボタンによって変化
                alignment: Alignment.topCenter,
                child: Text(word,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold))),
            Container(
                height: size.height * 0.10, //ホームに戻るボタンによって変化
                alignment: Alignment.topCenter,
                child: Text(yomi,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
            Container(
                padding: EdgeInsets.only(bottom:size.height * 0.05),
                alignment: Alignment.topCenter,
                width: size.width * 0.9,
                child: Text(imi,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
            Container(
                padding: EdgeInsets.only(bottom:size.height * 0.10),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromRGBO(253, 213, 53, 1),
                  fixedSize: Size(
                    size.width * 0.7,
                    size.height * 0.05,
                  ),
                  ),
                  child: const Text('次の問題へ進む'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/quiz_word');
                  }, 
                ),
            ),//ボタンを押した時の処理はここ
          ],
        ),
      ),
      bottomNavigationBar: const Footer()
    );
  }
}
