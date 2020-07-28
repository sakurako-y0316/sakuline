import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/todo_item.dart';

class ToDoItemScreemViewModel extends ChangeNotifier {
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

  List<ToDoItem> todoItems = [];
  String title;

  fetch(String todoId) async {
    // print('fetchします:$todoId');
    QuerySnapshot snapshot = await Firestore.instance
        .collection('todoItem')
        .where('todoId', isEqualTo: todoId)
        .getDocuments();

    List<ToDoItem> listToDoItems = snapshot.documents
        .map(
          (doc) => ToDoItem(
            title: doc.data['title'],
            todoItemId: doc.data['todoItemId'],
            todoId: doc.data['todoId'],
          ),
        )
        .toList();

    todoItems = listToDoItems;

    notifyListeners();
  }

  create(String todoId) async {
    String uuid = randomAlphaNumeric(20);
    await Firestore.instance.collection('todoItem').document(uuid).setData({
      'title': title,
      'todoId': todoId,
      'todoItemId': uuid,
    });
  }

  dalete(String uuid) async {
    await Firestore.instance.collection('todoItem').document(uuid).delete();
  }

  update(String uuid) async {
    await Firestore.instance
        .collection('todoItem')
        .document(uuid)
        .updateData({'title': title});
  }
}
