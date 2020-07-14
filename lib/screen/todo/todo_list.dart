import 'package:flutter/material.dart';
import 'package:sakura_line/screen/todo/bring_screen.dart';
import 'package:sakura_line/screen/todo/must_screen.dart';

TabController _controller;

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('TODOリスト'),
          bottom: TabBar(controller: _controller, tabs: _buildTabs())),
      body: TabBarView(
        controller: _controller,
        children: _buildTabPage(),
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
      )
    ];
  }

  List<Widget> _buildTabPage() {
    return [
      BringScreen(),
      MustScreen(),
    ];
  }
}
