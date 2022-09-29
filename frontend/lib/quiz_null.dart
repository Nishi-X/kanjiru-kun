import 'package:flutter/material.dart';
import 'Footer.dart';

class quiz_null extends StatelessWidget {
  String nameText = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "クイズ",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromRGBO(253, 213, 53, 1)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              textAlign: TextAlign.center,
              'My辞書に単語が\n登録されていないよ！',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      // ignore: prefer_const_constructors

      bottomNavigationBar: const Footer(),
    );
  }
}
