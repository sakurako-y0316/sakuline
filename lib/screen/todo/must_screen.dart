import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/model/todo_list.dart';
import 'package:sakura_line/screen/todo/add_todo.dart';
import 'package:sakura_line/view_model/todo_list_view_model.dart';

class MustScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoListViewModel>(
      create: (_) => ToDoListViewModel()..fetchtodos(),
      child: Scaffold(
        body: Consumer<ToDoListViewModel>(
          builder: (context, viewmodel, child) {
            final todos = viewmodel.todos;
            final List<Expanded> listTiles = todos
                .map(
                  (todo) => Expanded(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(todo.title),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) {
                                    return AddToDoScreen(todo: todo);
                                  },
                                  fullscreenDialog: true,
                                ),
                              );
                              viewmodel.fetchtodos();
                            },
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${todo.title}を削除しますか？'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await deleteToDo(
                                          context, viewmodel, todo);
                                    },
                                    child: Text('OK'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
                .toList();
            return ListView(
              children: listTiles,
              shrinkWrap: true,
            );
          },
        ),
        floatingActionButton:
            Consumer<ToDoListViewModel>(builder: (context, viewmodel, child) {
          return FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) {
                    return AddToDoScreen();
                  },
                  fullscreenDialog: true,
                ),
              );
              viewmodel.fetchtodos();
            },
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }

  Future deleteToDo(
    BuildContext context,
    ToDoListViewModel viewmodel,
    ToDo todo,
  ) async {
    try {
      await viewmodel.deleteToDo(todo);
      //更新
      await viewmodel.fetchtodos();
    } catch (e) {
      await _showDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future _showDialog(BuildContext context, String title) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
  }
}
