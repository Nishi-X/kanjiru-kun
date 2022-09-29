import 'package:flutter/material.dart';
import 'package:kanjurukun/Stampcard.dart';
//import 'package:flutter/src/material/bottom_navigation_bar.dart';
import 'Top.dart';
import 'Reading.dart';
import 'Quiz.dart';
import 'MyDict.dart';
import 'Stampcard.dart';
import 'Guruguru.dart';

//import 'Footer.dart';

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  int _idx = 1;

  void _navi_tapped(int idx) {
    List<String> names = ["/Top", "/MyDict"];
    String name = names[idx];
    Navigator.of(context).pushNamed(name);
    setState(() {
      _idx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Color(0xFF259EA5),
      unselectedItemColor: Color(0xFF259EA5),
      // fixedColor: Color(0xFF259EA5),
      onTap: _navi_tapped,
      currentIndex: _idx,
      items: const [
        BottomNavigationBarItem(
          // backgroundColor: Color(0x00737373),
          icon: Icon(Icons.home), // アイコン
          label: 'ホームに戻る', // ボタン名
        ),
        BottomNavigationBarItem(
          // backgroundColor: Color(0x00737373),
          icon: Icon(Icons.view_list), // アイコン
          label: 'My辞書', // ボタン名
        ),
      ],
    );
  }
}
