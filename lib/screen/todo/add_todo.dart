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
    return ChangeNotifierProvider<AddToDoViewModel>(
      create: (_) => AddToDoViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? 'ToDoリストを追加する' : 'TODOリストを編集する'),
        ),
        body: Consumer<AddToDoViewModel>(
          builder: (context, viewmodel, child) {
            return Column(
              children: <Widget>[
                TextField(
                  onChanged: (text) {
                    viewmodel.todoTitle = text;
                  },
                ),
                FlatButton(
                  child: Text(isUpdate ? '追加する！' : '更新する！'),
                  color: Colors.red[200],
                  onPressed: () async {
                    try {
                      await viewmodel.addToDoFirebase();
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
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(e.toString()),
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
}
