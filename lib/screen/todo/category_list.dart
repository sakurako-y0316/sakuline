import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/todo/todo_list.dart';
import 'package:sakura_line/view_model/todo_list_view_model.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ToDoListViewModel>(
      create: (_) => ToDoListViewModel()..fetchtodos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('目的別'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.accessibility),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                )
              ],
            )
          ],
        ), //呼び出し(Consumer)
        body: Consumer<ToDoListViewModel>(
          builder: (context, viewmodel, child) {
            return Stack(
              children: <Widget>[
                ListView(
                  children: List.generate(
                    viewmodel.todos.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) {
                                return ToDoList(
                                  title: viewmodel.todos[index].title,
                                );
                              },
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 150,
                                width: double.infinity,
                                child: viewmodel.todos[index].images == null
                                    ? Image.asset(
                                        'lib/assets/images/noimage.png')
                                    : Image.asset(
                                        viewmodel.todos[index].images),
                              ),
                              Container(
                                child: ListTile(
                                  title: Text(viewmodel.todos[index].title),
                                  leading: Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
