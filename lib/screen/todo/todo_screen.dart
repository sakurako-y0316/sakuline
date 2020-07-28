//リストでfirestoreから呼び出し
//FloatingActionButton作成
//create画面作成

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/todo/todo_item_screen.dart';
import 'package:sakura_line/view_model/todo_screen_view_model.dart';

class ToDoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoScreenViewModel>(
      create: (_) => ToDoScreenViewModel()..fetch(),
      child: Consumer<ToDoScreenViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text('ToDo'), Icon(Icons.flight_takeoff)],
              ),
            ),
            body: ListView.builder(
              itemCount: model.todos.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('lib/assets/images/travel.jpg'),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ToDoItemScreen(
                                  model.todos[index].title,
                                  model.todos[index].documentId,
                                );
                              },
                            ),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(model.todos[index].title),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await model
                                    .delete(model.todos[index].documentId);
                                model.fetch();
                              },
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditToDo(model.todos[index].title,
                                      model.todos[index].documentId);
                                },
                              ),
                            );
                            model.fetch();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return AddToDo();
                      },
                    ),
                  );
                  model.fetch();
                },
                child: Icon(Icons.add)),
          );
        },
      ),
    );
  }
}

class AddToDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoScreenViewModel>(
      create: (_) => ToDoScreenViewModel(),
      child: Consumer<ToDoScreenViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('追加'),
            ),
            body: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (val) {
                    model.title = val;
                  },
                ),
                FlatButton(
                  onPressed: () async {
                    await model.create();
                    Navigator.pop(context);
                  },
                  child: Text('追加'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditToDo extends StatelessWidget {
  final String title;
  final String documentId;

  const EditToDo(this.title, this.documentId);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoScreenViewModel>(
      create: (_) => ToDoScreenViewModel(),
      child: Consumer<ToDoScreenViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('更新'),
            ),
            body: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: title,
                  onChanged: (val) {
                    model.title = val;
                  },
                ),
                FlatButton(
                  onPressed: () async {
                    await model.update(documentId);
                    Navigator.pop(context);
                  },
                  child: Text('更新'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
