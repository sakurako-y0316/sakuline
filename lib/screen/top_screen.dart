import 'package:flutter/material.dart';
import 'package:sakura_line/screen/home_screen.dart';
import 'package:sakura_line/screen/news_screen.dart';
import 'package:sakura_line/screen/talk_screen.dart';
import 'package:sakura_line/screen/timeline_screen.dart';

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
          HomeScreen(),
          TalkScreen(),
          TimeLine(),
          NewsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.cyan,
        currentIndex: page,
        onTap: onTapBottomNavigation,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.brown[200],
              ),
              title: Text(
                'ホーム',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.brown[200],
              ),
              title: Text('トーク')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.brown[200],
              ),
              title: Text('タイムライン')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.brown[200],
              ),
              title: Text('ニュース？')),
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