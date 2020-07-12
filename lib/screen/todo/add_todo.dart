import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/model/todo_list.dart';
import 'package:sakura_line/view_model/add_todo_view_model.dart';

class AddToDoScreen extends StatelessWidget {
  AddToDoScreen({this.todo});
  final ToDo todo;
  @override
  Widget build(BuildContext context) {
    final bool isUpdate = todo != null;
    final textEditingController = TextEditingController();
    if (isUpdate) {
      textEditingController.text = todo.title;
    }

    return ChangeNotifierProvider<AddToDoViewModel>(
      create: (_) => AddToDoViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? 'TODOリストを編集する' : 'TODOリストを追加する'),
        ),
        body: Consumer<AddToDoViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              children: <Widget>[
                TextField(
                  controller: textEditingController,
                  onChanged: (text) {
                    viewmodel.todoTitle = text;
                  },
                ),
                FlatButton(
                  child: Text(isUpdate ? '更新する！' : '追加する！'),
                  color: Colors.red[200],
                  onPressed: () async {
                    if (isUpdate) {
                      await updateToDo(viewmodel, context);
                    } else {
                      await addToDo(viewmodel, context);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future addToDo(AddToDoViewModel viewModel, BuildContext context) async {
    try {
      await viewModel.addToDoFirebase();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました！'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext cotext) {
          return AlertDialog(
            title: Text(
              e.toString(),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
  }

  Future updateToDo(AddToDoViewModel viewmodel, BuildContext context) async {
    try {
      await viewmodel.updateToDo(todo);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[FlatButton(onPressed: () {}, child: Text('OK'))],
          );
        },
      );
    }
  }
}
