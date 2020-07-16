import 'package:flutter/material.dart';
import 'package:sakura_line/screen/todo/bring_screen.dart';
import 'package:sakura_line/screen/todo/must_screen.dart';
import 'package:sakura_line/screen/todo/shopping_screen.dart';

class ToDoList extends StatefulWidget {
  final String title;

  const ToDoList({this.title});

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            controller: _controller,
            tabs: _buildTabs(),
          ),
        ),
        body: TabBarView(
          children: _buildTabPage(),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return [
      Tab(
        icon: Icon(Icons.home),
        text: '持っていくもの',
      ),
      Tab(
        icon: Icon(Icons.label),
        text: 'やっておく事',
      ),
      Tab(
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.red[200],
        ),
        text: '買う物',
      )
    ];
  }

  List<Widget> _buildTabPage() {
    return [
      BringScreen(),
      MustScreen(),
      ShoppingScreen(),
    ];
  }
}
