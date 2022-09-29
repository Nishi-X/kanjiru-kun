import 'package:flutter/material.dart';
import 'Top.dart';
import 'Footer.dart';

class Stampcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("スタンプカード", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFDD535),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: TextButton(
            onPressed: () => {Navigator.of(context).pushNamed("/Top")},
            child: const Text("未実装です！", style: TextStyle(fontSize: 50))),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
