import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sakura_line/model/todo_item.dart';
import 'package:sakura_line/view_model/todo_item_screen_view_model.dart';

class ToDoItemScreen extends StatelessWidget {
  final String title;
  final String todoId;
  const ToDoItemScreen(this.title, this.todoId);

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
                    )
                  ],
                  secondaryActions: <Widget>[
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
                    title: Text(model.todoItem[index].title),
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
                    child: Text('作成する'))
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
                    await model.update(toDoItems.todoItemId, toDoItems);
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
