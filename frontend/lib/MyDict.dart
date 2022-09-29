import 'package:flutter/material.dart';
//import 'Top.dart';
import 'KanjiData.dart';
import 'Footer.dart';

// DB用
import 'package:sqflite/sqflite.dart';

class MyDict extends StatefulWidget {
  const MyDict({Key? key}) : super(key: key);

  @override
  _MyDict createState() => _MyDict();
}

class _MyDict extends State<MyDict> {
  List<Map<String, dynamic>> _KanjiData = [];

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await KanjiData.read_all();
    setState(() {
      _KanjiData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _yomiController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();

// リストをタッチしたときにポップアップを表示する関数
  Future openDictup(
      BuildContext context, String yomi, String word, String meaning) async {
    var exist = await KanjiData.exist(word, yomi);
    var answer = await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Column(
                children: [
                  Text(
                    '$yomi',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                  Text(
                    '$word',
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
                      textAlign: TextAlign.center,
                      '単語を辞書に登録',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      await KanjiData.write(word, yomi, meaning);
                      Navigator.pop(context, '\'単語を辞書に登録\'が選択されました');
                    },
                  ),
                //既登録時処理
                if (exist)
                  SimpleDialogOption(
                    child: Text(
                      textAlign: TextAlign.center,
                      '単語を辞書から削除',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.red),
                    ),
                    onPressed: () {
                      KanjiData.deleteItemByWordYomi(word, yomi);
                      Navigator.pop(context, '\'単語を辞書から削除\'が選択されました');
                    },
                  ),
                SimpleDialogOption(
                  child: Text(
                    textAlign: TextAlign.center,
                    '閉じる',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.pop(context, '\'閉じる\'が選択されました');
                  },
                )
              ],
            ));
  }

// フォーム
  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _KanjiData.firstWhere((element) => element['id'] == id);
      _wordController.text = existingJournal['word'];
      _yomiController.text = existingJournal['yomi'];
      _meaningController.text = existingJournal['meaning'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _wordController,
                    decoration: const InputDecoration(hintText: '単語'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _yomiController,
                    decoration: const InputDecoration(hintText: '読み'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _meaningController,
                    decoration: const InputDecoration(hintText: '意味'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }
                      _wordController.text = '';
                      _yomiController.text = '';
                      _meaningController.text = '';

                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

// add
  Future<void> _addItem() async {
    await KanjiData.write(
        _wordController.text, _yomiController.text, _meaningController.text);
    _refreshJournals();
  }

// update
  Future<void> _updateItem(int id) async {
    await KanjiData.updateItem(id, _wordController.text, _yomiController.text,
        _meaningController.text);
    _refreshJournals();
  }

// delete
  void _deleteItem(int id) async {
    await KanjiData.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a word!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My辞書', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFDD535),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _KanjiData.length,
              itemBuilder: (context, index) /*=> Card*/ {
                return new GestureDetector(
                  onTap: () {
                    openDictup(
                        context,
                        _KanjiData[index]['yomi'],
                        _KanjiData[index]['word'],
                        _KanjiData[index]['meaning']);
                  },
                  child: new Card(
                    color: Color(0xFF259EA5),
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(_KanjiData[index]['word'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(_KanjiData[index]['yomi'],
                          style: TextStyle(color: Colors.white)),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showForm(_KanjiData[index]['id']),
                              color: Colors.white,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteItem(_KanjiData[index]['id']),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF259EA5),
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
