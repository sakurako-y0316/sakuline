import 'package:flutter/material.dart';
import 'package:sakura_line/screen/home/mypage_screen.dart';

import 'package:sakura_line/screen/talk_screen.dart';
import 'package:sakura_line/screen/timeline_screen.dart';
import 'package:sakura_line/screen/todo/category_list.dart';
import 'package:sakura_line/screen/todo/todo_list.dart';

class TopScreen extends StatefulWidget {
  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  PageController _pageController;
  int page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onchanged,
        children: <Widget>[
          MyPageScreen(),
          TalkScreen(),
          TimeLine(),
          CategoryList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.red[100],
        currentIndex: page,
        onTap: onTapBottomNavigation,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.face), title: Text('マイぺージ')),
          BottomNavigationBarItem(icon: Icon(Icons.send), title: Text('トーク')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              title: Text('タイムライン')),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available), title: Text('TODOリスト')),
        ],
      ),
    );
  }

  void onTapBottomNavigation(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onchanged(int page) {
    setState(() {
      this.page = page;
    });
  }
}
