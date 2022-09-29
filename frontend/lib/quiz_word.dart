import 'package:flutter/material.dart';
import 'Footer.dart';
import 'KanjiData.dart';

class quiz_word extends StatefulWidget {
  quiz_word({Key? key}) : super(key: key);
  State<quiz_word> createState() => _quiz_word();
}

class _quiz_word extends State<quiz_word> {
  String input_text = "", word = "", yomi = "", imi = "";
  bool loaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (loaded == false) {
      loaded = true;
      var kanjiWord = await KanjiData.read_random();
      word = kanjiWord[0]["word"];
      yomi = kanjiWord[0]["yomi"];
      imi = kanjiWord[0]["meaning"];
    }
  }
  // todo: ここに処理を書く

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "クイズの回答",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromRGBO(253, 213, 53, 1)),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: size.height * 0.20),
                  Text(
                    word,
                    style: TextStyle(fontSize: 36),
                  ),
                  Text("〇" * yomi.length, style: TextStyle(fontSize: 20)),
                ],
              ),
              Container(
                alignment: Alignment(0.0, 0.2),
                width: size.width * 0.7,
                height: size.height * 0.3,
                child: TextField(
                  autofocus: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  enableInteractiveSelection: false,
                  maxLength:100,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    hintText: '答えを入力してね！',
                  ),
                  onChanged: (text) {
                    input_text = text;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromRGBO(253, 213, 53, 1),
                  fixedSize: Size(
                    size.width * 0.7,
                    size.height * 0.05,
                  ),
                ),
                child: const Text('回答する!'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/quiz_answer',
                      arguments: View_dic(input_text, word, yomi, imi));
                }, //ボタンを押した時の処理はここ
              ),
            ],
          ),
        ),

        // ignore: prefer_const_constructors
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}

//答えとmy辞書の中身を保存するクラス
class View_dic {
  String input_text, word, yomi, imi;
  View_dic(this.input_text, this.word, this.yomi, this.imi);
}
