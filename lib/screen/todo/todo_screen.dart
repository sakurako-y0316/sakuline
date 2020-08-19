//リストでfirestoreから呼び出し
//FloatingActionButton作成
//create画面作成

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/model/todo.dart';
import 'package:sakura_line/screen/todo/todo_item_screen.dart';
import 'package:sakura_line/view_model/todo_screen_view_model.dart';
import 'package:image_picker/image_picker.dart';

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
                return Column(
                  children: <Widget>[
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
                      title: Column(
                        children: <Widget>[
                          model.todos[index].images == null
                              ? Container(
                                  height: 200,
                                  child: Image.asset(
                                      'lib/assets/images/noimage.png'),
                                )
                              : Container(
                                  height: 200,
                                  child: Image.network(
                                    model.todos[index].images,
                                  ),
                                ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(model.todos[index].title),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // _deleteDialog(context, model.todos[index]);
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('キャンセル'),
                                                ),
                                                FlatButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await _deleteToDo(
                                                        context,
                                                        model,
                                                        model.todos[index]
                                                            .documentId,
                                                      );
                                                    },
                                                    child: Text('OK')),
                                              ],
                                            )
                                          ],
                                          title: Text(
                                              '${model.todos[index].title}\nを削除しますか？'),
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return EditToDo(model.todos[index]);
                                        },
                                      ),
                                    );
                                    model.fetch();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Future _deleteToDo(BuildContext context, ToDoScreenViewModel model,
      String documentId) async {
    try {
      await model.delete(documentId);
      await model.fetch();
    } catch (e) {
      await _showDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future<dynamic> _showDialog(
    BuildContext context,
    String title,
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoScreenViewModel>(
      create: (_) => ToDoScreenViewModel()..fetch(),
      child: Consumer<ToDoScreenViewModel>(
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: Text('イベント新規作成'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: 'イベントを入力してください'),
                        onChanged: (val) {
                          model.title = val;
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      model.imageFile != null
                          ? Image.file(model.imageFile)
                          : Container(
                              color: Colors.grey,
                              width: double.infinity,
                              height: 250,
                            ),
                      FlatButton(
                        color: Colors.red[200],
                        onPressed: () {
                          selectImageBottomSheet(context, model);
                        },
                        child: Text('画像を設定する'),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      FlatButton(
                        color: Colors.red[200],
                        onPressed: () async {
                          model.startLoading();
                          await model.create();
                          Navigator.pop(context);
                          model.endLoading();
                        },
                        child: Text('作成'),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<ToDoScreenViewModel>(builder: (context, model, child) {
                return model.isLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox();
              })
            ],
          );
        },
      ),
    );
  }

  Future<void> selectImageBottomSheet(
      BuildContext context, ToDoScreenViewModel model) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'ライブラリから選択',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                model.setImage(File(pickedFile.path));
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'カメラ撮影',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                // getImage();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'キャンセル',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

class EditToDo extends StatelessWidget {
  final ToDo todo;

  EditToDo(this.todo);
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoScreenViewModel>(
      create: (_) => ToDoScreenViewModel(),
      child: Consumer<ToDoScreenViewModel>(
        builder: (context, model, child) {
          return Stack(
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  title: Text('更新'),
                ),
                body: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: todo.title,
                      onChanged: (val) {
                        model.title = val;
                      },
                    ),
                    FlatButton(
                      color: Colors.red[200],
                      onPressed: () async {
                        await model.update(todo.documentId, todo);
                        Navigator.pop(context);
                      },
                      child: Text('更新'),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    model.imageFile != null
                        ? Image.file(model.imageFile)
                        : Container(
                            child: Image.network(todo.images),
                            height: 250,
                            width: double.infinity,
                          ),
                    FlatButton(
                      color: Colors.red[200],
                      onPressed: () {
                        updateImageBottomSheet(context, model);
                      },
                      child: Text('画像を変更する'),
                    )
                  ],
                ),
              ),
              Consumer<ToDoScreenViewModel>(builder: (context, model, child) {
                return model.isLoading
                    ? Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox();
              }),
            ],
          );
        },
      ),
    );
  }

  Future<void> updateImageBottomSheet(
      BuildContext context, ToDoScreenViewModel model) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'ライブラリから選択',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () async {
                final pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                model.setImage(File(pickedFile.path));
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'カメラ撮影',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                // getImage();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'キャンセル',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
