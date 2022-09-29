import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
//import 'Top.dart';
//import 'Footer.dart';

class Top extends StatefulWidget {
  @override
  State<Top> createState() => _Top();
}

class _Top extends State<Top> {
  @override
  Widget build(BuildContext context) {
    // サイズなど
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final double deviceWidth = MediaQuery.of(context).size.width;
    var maxHeight = size.height - padding.top - padding.bottom;

    // ロゴエリアの縦サイズ
    final logoHeight = maxHeight * (30 / 100);
    // ボタンエリアの縦サイズ
    final bottonHeight = maxHeight * (40 / 100);
    // 余白
    final paddingHeight = padding.top + padding.bottom;

    // 撮影
    final _picker = ImagePicker();
    File _image;
    var imgFlg = false;
    Future getImage() async {
      if (Platform.isAndroid || Platform.isIOS) {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);

        setState(() {
          if (pickedFile != null) {
            try {
              _image = File(pickedFile.path);
              imgFlg = true;
              debugPrint("from: take");
              debugPrint(_image.path);
              Navigator.of(context)
                  .pushNamed("/Guruguru", arguments: _image.path);
            } catch (e) {
              imgFlg = false;
            }
          }
        });
      } else {
        debugPrint("no mobile");
        Navigator.of(context)
            .pushNamed("/Guruguru", arguments: "images/kobayashi.jpg");
      }
    }

    // 画像選択
    Future pickImage() async {
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          debugPrint("pick image");
          final image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          // 画像がnullの場合戻る
          if (image == null) return;
          _image = File(image.path);
          debugPrint("from: pick");
          debugPrint(_image.path);
          Navigator.of(context).pushNamed("/Guruguru", arguments: _image.path);
          // setState(() => _image = imageTemp);
        } on PlatformException catch (e) {
          debugPrint('Failed to pick image: $e');
        }
      } else {
        debugPrint("no mobile");
        Navigator.of(context)
            .pushNamed("/Guruguru", arguments: "images/kobayashi.jpg");
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text("漢字を感じて知るリーダー", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFDD535),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            /*Container(
              //余白
              width: deviceWidth,
              height: paddingHeight,
            ),*/
            SizedBox(
              // 余白
              width: deviceWidth,
              height: logoHeight / 4,
            ),
            Container(
              //ロゴ
              width: deviceWidth,
              height: logoHeight,
              child: Image.asset('images/logo.png'),
            ),
            /*Container(
              //余白
              width: deviceWidth,
              height: 3 * paddingHeight,
            ),
            */
            SizedBox(
              // 余白
              width: deviceWidth,
              height: logoHeight / 4,
            ),
            Container(
              //ボタン
              width: deviceWidth,
              height: bottonHeight,
              child: Column(
                children: [
                  ElevatedButton(
                    // 漢字読み取りボタン
                    child: const Text(
                      "漢字読み取り",
                      style: TextStyle(fontSize: 30),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFDD535),
                      onPrimary: Colors.black,
                      fixedSize: Size(
                        size.width * 0.7, //70%
                        50,
                      ),
                    ),
                    onPressed: () => {
                      // ポップアップ
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            //title: Text("タイトル"),
                            children: <Widget>[
                              // コンテンツ領域
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(context),
                                child: TextButton(
                                  onPressed: getImage,
                                  child: const Text("カメラで読み取る"),
                                ),
                              ),
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(context),
                                child: TextButton(
                                  onPressed: pickImage,
                                  child: const Text("画像から読み取る"),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    },
                  ),
                  SizedBox(
                    // ボタンの間隔
                    height: logoHeight / 4,
                  ),
                  //クイズボタン
                  ElevatedButton(
                    child: const Text(
                      "クイズ",
                      style: TextStyle(fontSize: 30),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFDD535),
                      onPrimary: Colors.black,
                      fixedSize: Size(
                        size.width * 0.7, //70%
                        50,
                      ),
                    ),
                    onPressed: () =>
                        {Navigator.of(context).pushNamed("/quiz_top")},
                  ),
                  SizedBox(
                    // 余白
                    width: deviceWidth,
                    height: logoHeight / 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton(
                        // My辞書ボタン
                        child: const Text(
                          "My辞書",
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            size.width * 0.5, //50%
                            50,
                          ),
                          primary: Color(0xFFFDD535),
                          onPrimary: Colors.black,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            {Navigator.of(context).pushNamed("/MyDict")},
                      ),
                      ElevatedButton(
                        // スタンプカードボタン
                        child: const Text(
                          "スタンプ\nカード",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                            size.width * 0.5, //50%
                            50,
                          ),
                          primary: Color(0xFFFDD535),
                          onPrimary: Colors.black,
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.white,
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        onPressed: () =>
                            {Navigator.of(context).pushNamed("/Stampcard")},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
