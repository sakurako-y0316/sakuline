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
              title: Text(title),
            ),
            body: ListView.builder(
              itemCount: model.todoItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(model.todoItems[index].title);
              },
            ),
          );
        },
      ),
    );
  }
}
