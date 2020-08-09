import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                          return AddToDoItem(title, todoId);
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
              itemCount: model.todoItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text(model.todoItems[index].title));
              },
            ),
          );
        },
      ),
    );
  }
}

class AddToDoItem extends StatelessWidget {
  final String title;
  final String todoId;

  const AddToDoItem(this.title, this.todoId);

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
