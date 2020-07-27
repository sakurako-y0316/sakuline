import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/home/mypage_edit.dart';
import 'package:sakura_line/screen/login_screen.dart';
import 'package:sakura_line/view_model/login_screen_view_model.dart';
import 'package:sakura_line/view_model/mypage_view_model.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>(
      create: (_) => MyPageViewModel(),
      // ..fetchusers(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('マイページ'),
          actions: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.red[100],
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.flight_takeoff,
                    color: Colors.red[100],
                  ),
                  onPressed: () {
                    _logoutDaialog(context);
                  },
                ),
              ],
            )
          ],
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.red[100],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) {
                    return MyPageEdit();
                  },
                ),
              );
            },
          ),
        ),
        body: Consumer<MyPageViewModel>(
          builder: (context, viewmodel, child) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 100,
                        child: Image.asset('lib/assets/images/0007.jpg')),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      viewmodel.userName == null
                          ? '名前を登録してください'
                          : viewmodel.userName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('1990/03/16')
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _logoutDaialog(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: false,
          title: Container(
            height: 200,
            width: 200,
            child: ChangeNotifierProvider<LoginScreenViewModel>(
                create: (_) => LoginScreenViewModel(),
                child: Consumer<LoginScreenViewModel>(
                    builder: (context, viewmodel, child) {
                  return Column(
                    children: <Widget>[
                      Text('ログアウトしますか？'),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('キャンセル'),
                          ),
                          FlatButton(
                            onPressed: () async {
                              try {
                                await viewmodel.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) {
                                      return LoginScreen();
                                    },
                                  ),
                                );
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text('ログアウト'),
                          ),
                        ],
                      ),
                    ],
                  );
                })),
          ),
        );
      },
    );
  }
}
