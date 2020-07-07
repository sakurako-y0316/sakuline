import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sakura_line/model/todo_list.dart';

class ToDoListViewModel extends ChangeNotifier {
  //modelと同じ名前ToDo
  List<ToDo> todos = [];

  Future fetchtodos() async {
    final docs = await Firestore.instance.collection('todo').getDocuments();
    final todos = docs.documents.map((doc) => ToDo(doc)).toList();
    this.todos = todos;
    print("チェック1：${todos[0].title}");
    print("チェック2：${this.todos[0].title}");
    notifyListeners();
  }
}
