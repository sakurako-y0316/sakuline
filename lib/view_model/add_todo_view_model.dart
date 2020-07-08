import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sakura_line/model/todo_list.dart';

class AddToDoViewModel extends ChangeNotifier {
  String todoTitle = '';
  List<ToDo> todos = [];

  Future addToDoFirebase() async {
    //空かどうかを判断(isEmpty)
    if (todoTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }

    Firestore.instance.collection('todo').add(
      {
        //足したい項目はここに
        'title': todoTitle,
        'created': Timestamp.now(),
      },
    );
  }

  Future updateToDo(ToDo todo) async {
    final document =
        Firestore.instance.collection('todo').document(todo.documentID);
    await document.updateData({
      'title': todoTitle,
      'updateAt': Timestamp.now(),
    });
  }
}
