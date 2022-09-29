import 'package:flutter/material.dart';
import 'KanjiData.dart';
import 'Footer.dart';

//テキスト表示＆単語押して意味表示
class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //解析結果受け取り
    final Map text = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "解析結果",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffdd535),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        // 文字ごとに押せる押せない分けるので単語単位でWidget作成
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                for (var data in text['detail'])
                  // 漢字の熟語意外は通常のテキスト扱い
                  if ((data['meaning'][0] == '(') ||
                      !(RegExp(r'[\u4E00-\u9FFF]').hasMatch(data['original'])))
                    Text(
                      data['original'],
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        height: 1.5,
                      ),
                    )
                  // 漢字の熟語は押せるようにしてポップアップを表示
                  else
                    GestureDetector(
                      onTap: () {
                        openPopup(context, data['read'], data['original'],
                            data['meaning']);
                      },
                      child: Text(
                        data['original'],
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.underline,
                          fontSize: 24,
                          height: 1.5,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }

  //ポップアップ表示
  Future openPopup(BuildContext context, String read, String original,
      String meaning) async {
    var exist = await KanjiData.exist(original, read);
    var answer = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Column(
                children: [
                  Text(
                    '$read',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                  Text(
                    '$original',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  Text(
                    '$meaning',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
                  ),
                ],
              ),
              children: [
                //未登録時処理
                if (!exist)
                  SimpleDialogOption(
                    child: Text(
                      '単語を辞書に登録',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      await KanjiData.write(original, read, meaning);
                      Navigator.pop(context, '\'単語を辞書に登録\'が選択されました');
                    },
                  ),
                //既登録時処理
                if (exist)
                  SimpleDialogOption(
                    child: Text(
                      '単語を辞書から削除',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      KanjiData.deleteItemByWordYomi(original, read);
                      Navigator.pop(context, '\'単語を辞書から削除\'が選択されました');
                    },
                  ),
                SimpleDialogOption(
                  child: Text(
                    '閉じる',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context, '\'閉じる\'が選択されました');
                  },
                )
              ],
            ));
  }
}
