import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/todo.dart';
import 'package:image_picker/image_picker.dart';

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
  final todos = <ToDo>[];
//createで使う
  String title;
  File imageFile;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }
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
            images: doc.data['images'],
          ),
        )
        .toList();

// ③リスト化しがデータを、クラス内に定義した空のリストに代入
    this.todos.clear();
    this.todos.addAll(todoList);
// ④変更したことを”通知”する
    notifyListeners();
  }

//---------------------------------
// データ登録
//---------------------------------
  create() async {
    if (title.isEmpty) {
      throw ('タイトルを入力してください');
    }

    // ①乱数を生成
    String uuid = randomAlphaNumeric(20);
    final images = await uploadImageFile();
    try {
      // ②Firestoreに登録処理
      Firestore.instance.collection('todo').document(uuid).setData(
        {
          'title': title,
          'documentId': uuid,
          'images': images,
          'createdAt': Timestamp.now(),
        },
      );
    } catch (e) {
      //
      print('登録失敗' + e.toString());
    }
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
    final images = await uploadImageFile();
    await Firestore.instance
        .collection('todo')
        .document(uuid)
        .updateData({'title': title, 'images': images});
  }

  Future getEventImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<String> uploadImageFile() async {
    if (imageFile == null) {
      return '';
    }
    print('タイトル:$title');
    print('ファイル:$imageFile');
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('todo').child(title);
    final snapshot = await ref
        .putFile(
          imageFile,
        )
        .onComplete;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
