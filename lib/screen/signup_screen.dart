import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/login_screen.dart';
import 'package:sakura_line/view_model/signup_screen_view_model.dart';

import 'top_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignUpScreenViewModel>(
      create: (_) => SignUpScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
        ),
        body: Consumer<SignUpScreenViewModel>(
            builder: (context, viewmodel, child) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 350,
                ),
                Container(
                  color: Colors.brown[200],
                  height: 50,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    onChanged: (text) {
                      viewmodel.mail = text;
                    },
                    controller: mailController,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  color: Colors.brown[200],
                  height: 50,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
                  child: TextField(
                    onChanged: (text) {
                      viewmodel.password = text;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'パスワード',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.brown[700],
                  height: 50,
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: FlatButton(
                    onPressed: () async {
                      try {
                        await viewmodel.signUp();
                        _showDialog(context, '登録完了しました');
                      } catch (e) {
                        _showDialog(context, e.toString());
                      }
                    },
                    child: Text(
                      '新規登録',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}
