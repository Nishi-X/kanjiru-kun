import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'Top.dart';

class Guruguru extends StatefulWidget {
  final Object? image; //上位Widgetから受け取りたいデータ
  Guruguru({required this.image}); //コンストラクタ

  @override
  _Guruguru createState() => _Guruguru();
}

class _Guruguru extends State<Guruguru> with RouteAware {
//画面遷移してすぐ実行するためのもの
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  //ここが実行される
  void didPush() {
    api();
  }

  // api叩いて'data'にjson形式で格納する -> textと一緒にページ遷移
  void api() async {
    var path = widget.image as String;
    final httpImage = await http.MultipartFile.fromPath('file', path);
    final uri = Uri.parse('https://api.kanjiru.net/analysis');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(httpImage);
    final response = await request.send();
    var body = await response.stream.bytesToString();
    var data = json.decode(body);
    if (!mounted) return;
    Navigator.of(context).pushNamed('/text', arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Now Loarding...",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfffdd535),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      //ぐるぐる表示
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xfffdd535)),
        ),
      ),
    );
  }
}
