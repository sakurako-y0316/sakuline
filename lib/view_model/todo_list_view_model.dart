import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sakura_line/model/todo_list.dart';

class ToDoListViewModel extends ChangeNotifier {
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

  //modelと同じ名前ToDo
  List<ToDo> todos = [];
  String todoTitle = '';
//コレクションごと取ってきている
  Future fetchtodos() async {
    final docs = await Firestore.instance.collection('todo').getDocuments();
    final todos = docs.documents.map((doc) => ToDo(doc)).toList();
    this.todos = todos;

    notifyListeners();
  }

  Future deleteToDo(ToDo todo) async {
    await Firestore.instance
        .collection('todo')
        .document(todo.documentID)
        .delete();
  }
}
