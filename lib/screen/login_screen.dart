import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/home/home_screen.dart';
import 'package:sakura_line/screen/signup_screen.dart';
import 'package:sakura_line/screen/top_screen.dart';
import 'package:sakura_line/view_model/login_screen_view_model.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginScreenViewModel>(
      create: (_) => LoginScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Consumer<LoginScreenViewModel>(
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
                      controller: mailController,
                      onChanged: (text) {
                        viewmodel.mail = text;
                      },
                      decoration: InputDecoration(
                        hintText: 'メールアドレス',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.brown[200],
                    height: 50,
                    margin: EdgeInsets.only(
                        left: 16, right: 16, top: 15, bottom: 15),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (text) {
                        viewmodel.password = text;
                      },
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
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 15),
                    child: FlatButton(
                      onPressed: () async {
                        try {
                          await viewmodel.login();
                          _showDialog(context, 'ログインしました');
                        } catch (e) {
                          _showDialog(context, e.toString());
                        }
                      },
                      child: Text(
                        'ログイン',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.brown[700],
                    height: 50,
                    margin: EdgeInsets.only(left: 16, right: 16),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'アカウントをお持ちでない方は新規登録',
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              ),
            );
          },
        ),
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
                          return TopScreen();
                        },
                      ),
                    );
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}
