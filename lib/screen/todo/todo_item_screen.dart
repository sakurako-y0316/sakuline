import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sakura_line/model/todo_item.dart';
import 'package:sakura_line/view_model/todo_item_screen_view_model.dart';

class ToDoItemScreen extends StatelessWidget {
  final String title;
  final String todoId;

  const ToDoItemScreen(
    this.title,
    this.todoId,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoItemScreemViewModel>(
      create: (_) => ToDoItemScreemViewModel()..fetch(todoId),
      child: Consumer<ToDoItemScreemViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AddToDoItem(todoId);
                        },
                      ),
                    );
                    model.fetch(todoId);
                  },
                ),
              ],
              title: Text(title),
            ),
            body: ListView.builder(
              itemCount: model.todoItem.length,
              itemBuilder: (context, index) => Card(
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      onTap: () async {
                        //買うもの、持ち物、その他add_shopping_cart、
//luggage,more
                        //async,await
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute<void>(builder: (context) {
                        //     return EditToDoItem(model.todoItem[index]);
                        //   }),
                        // ); //ここでフェッチ　したら、戻ると同時に更新する
                        // model.fetch(todoId);
                      },
                      caption: '',
                      color: Colors.blue,
                      icon: Icons.add_shopping_cart,
                    ),
                    IconSlideAction(
                      color: Colors.orange,
                      caption: '',
                      icon: Icons.language,
                    ),
                    IconSlideAction(
                      color: Colors.orange,
                      caption: '',
                      icon: Icons.more,
                    )
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      onTap: () async {
                        await model.doneItem(
                          model.todoItem[index].todoItemId,
                          model.todoItem[index].done,
                        );
                        model.fetch(todoId);
                      },
                      caption: model.todoItem[index].done == true ? '戻す' : '完了',
                      color: model.todoItem[index].done == true
                          ? Colors.white30
                          : Colors.green,
                      icon: model.todoItem[index].done == true
                          ? Icons.cached
                          : Icons.done_outline,
                    ),
                    IconSlideAction(
                      onTap: () async {
                        //async,await
                        await Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (context) {
                            return EditToDoItem(model.todoItem[index]);
                          }),
                        ); //ここでフェッチ　したら、戻ると同時に更新する
                        model.fetch(todoId);
                      },
                      caption: '編集',
                      color: Colors.blue,
                      icon: Icons.edit,
                    ),
                    IconSlideAction(
                      onTap: () async {
                        await model.dalete(
                          model.todoItem[index].todoItemId,
                        );
                        model.fetch(todoId);
                      },
                      caption: '削除',
                      color: Colors.red,
                      icon: Icons.delete,
                    )
                  ],
                  child: ListTile(
                    leading: model.todoItem[index].done == true
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.red,
                          )
                        : Text(''),
                    title: model.todoItem[index].done == true
                        ? Text(
                            model.todoItem[index].title,
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : Text(model.todoItem[index].title),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddToDoItem extends StatelessWidget {
  final String todoId;

  const AddToDoItem(this.todoId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoItemScreemViewModel>(
      create: (_) => ToDoItemScreemViewModel()..fetch(todoId),
      child: Consumer<ToDoItemScreemViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('TODOリスト作成'),
            ),
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: '内容を入力くだしてください'),
                  onChanged: (val) {
                    model.title = val;
                  },
                ),
                FlatButton(
                  color: Colors.yellow,
                  onPressed: () async {
                    await model.create(todoId);
                    Navigator.pop(context);
                  },
                  child: Text('作成する'),
                ),
                SizedBox(
                  height: 50,
                ),
                FlatButton(
                  color: Colors.red[200],
                  onPressed: () {},
                  child: Text('カテゴリーを選択する'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditToDoItem extends StatelessWidget {
  final ToDoItem toDoItems;

  const EditToDoItem(this.toDoItems);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoItemScreemViewModel>(
      create: (_) => ToDoItemScreemViewModel(),
      child: Consumer<ToDoItemScreemViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('TODOリストを編集'),
            ),
            body: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: toDoItems.title,
                  onChanged: (val) {
                    model.title = val;
                  },
                ),
                FlatButton(
                  color: Colors.red[200],
                  onPressed: () async {
                    await model.update(
                        todoItemId: toDoItems.todoItemId, toDoItem: toDoItems);
                    Navigator.pop(context);
                  },
                  child: Text('更新する'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
