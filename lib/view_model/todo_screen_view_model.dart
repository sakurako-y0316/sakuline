import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/todo.dart';

class ToDoScreenViewModel extends ChangeNotifier {
  //------------------------
  // disposeのエラー問題解決
  //------------------------
  bool _mounted = true;

  @override
  void notifyListeners() {
    if (_mounted) super.notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  //------------------------
  // ↑↑ここまで
  //------------------------

//空のリスト
  List<ToDo> todos = [];
//createで使う
  String title;
//---------------------------------
// リスト取得
//---------------------------------

// ①Firestoreにアクセスして、データの塊を取得
  fetch() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('todo').getDocuments();

// ②データの塊をToDoのモデルに順に入れて、最後にリスト化(title,idを取りたい)
    List<ToDo> todoList = snapshot.documents
        .map(
          (doc) => ToDo(
            title: doc.data['title'],
            documentId: doc.data['documentId'],
          ),
        )
        .toList();

// ③リスト化しがデータを、クラス内に定義した空のリストに代入
    this.todos = todoList;
// ④変更したことを”通知”する
    notifyListeners();
  }

//---------------------------------
// データ登録
//---------------------------------
  create() async {
    // ①乱数を生成
    String uuid = randomAlphaNumeric(20);
// ②Firestoreに登録処理
    Firestore.instance.collection('todo').document(uuid).setData(
      {
        'title': title,
        'documentId': uuid,
        'createdAt': Timestamp.now(),
      },
    );
  }

//---------------------------------
// データ削除
//---------------------------------
  delete(String uuid) async {
    await Firestore.instance.collection('todo').document(uuid).delete();
  }

//---------------------------------
// データ更新
//---------------------------------
  update(String uuid) async {
    await Firestore.instance
        .collection('todo')
        .document(uuid)
        .updateData({'title': title});
  }
}
