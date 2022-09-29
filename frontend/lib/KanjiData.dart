import 'package:flutter/material.dart';
import 'Top.dart';
//import 'Reading.dart';
//import 'Quiz.dart';
//import 'MyDict.dart';
//import 'Stampcard.dart';
//import 'Guruguru.dart';
//import 'ReturnHome.dart';

// KanjiData用
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

// ランダマイズ
import 'dart:math';

class KanjiData {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY NOT NULL,
        word TEXT,
        yomi TEXT,
        meaning TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("CREATE INDEX word ON items(word, yomi)");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Kanji.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

// write
  static Future<int> write(String original, String read, String meaning) async {
    final db = await KanjiData.db();

    final data = {'word': original, 'yomi': read, 'meaning': meaning};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

//exist 単語が既に登録されているかどうか
  static Future<bool> exist(String original, String read) async {
    final db = await KanjiData.db();
    final List = await db.query('items',
        where: "word = ?", whereArgs: [original], limit: 1);
    if (List.isNotEmpty &&
        List[0]["word"] == original &&
        List[0]["yomi"] == read) {
      return true;
    }
    return false;
  }

//read_all 読みでソート
  static Future<List<Map<String, dynamic>>> read_all() async {
    final db = await KanjiData.db();
    return db.query('items', orderBy: "yomi");
  }

//read_random ランダムに取得
  static Future<List<Map<String, dynamic>>> read_random() async {
    final db = await KanjiData.db();

    var res = await db.query('items', orderBy: "RANDOM()");
    return (res);
  }

// update　使わない
  static Future<int> updateItem(
      int id, String word, String yomi, String meaning) async {
    final db = await KanjiData.db();

    final data = {
      'word': word,
      'yomi': yomi,
      'meaning': meaning,
      //'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

// delete（なくてもいいかも）
  static Future<void> deleteItem(int id) async {
    final db = await KanjiData.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

// テスト用delete
  static Future<void> deleteItemByWordYomi(String original, String read) async {
    final db = await KanjiData.db();
    try {
      await db.delete("items",
          where: "word = ? and yomi = ?", whereArgs: [original, read]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
