import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/todo_list_view_model.dart';

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoListViewModel>(
      create: (_) => ToDoListViewModel()..fetchtodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODOリスト'),
        ),
        body: Consumer<ToDoListViewModel>(builder: (context, viewmodel, child) {
          final todos = viewmodel.todos;
          print('チェック２${todos.length}');
          final List<ListTile> listTiles = todos
              .map(
                (todo) => ListTile(
                  title: Text(todo.title),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {},
                  ),
                ),
              )
              .toList();
          return ListView(children: listTiles);
        }),
      ),
    );
  }
}
