import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/login_screen.dart';
import 'package:sakura_line/screen/top_screen.dart';
import 'package:sakura_line/view_model/signup_screen_view_model.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return ChangeNotifierProvider<SignUpScreenViewModel>(
      create: (_) => SignUpScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
        ),
        body: Consumer<SignUpScreenViewModel>(
            builder: (context, viewmodel, child) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _textForm(viewmodel, nameController, '名前'),
                _textForm(viewmodel, mailController, 'メールアドレス'),
                _textForm(viewmodel, passwordController, 'パスワード'),
                Container(
                  width: double.infinity,
                  color: Colors.brown[700],
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20),
                  child: FlatButton(
                    onPressed: () async {
                      try {
                        await viewmodel.signUp(
                          nameController,
                          mailController,
                          passwordController,
                        );
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
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  //-----------------------------------------
  // Formの共通化
  //-----------------------------------------
  Widget _textForm(SignUpScreenViewModel model,
      TextEditingController controller, String title) {
    return Container(
      color: Colors.brown[200],
      height: 50,
      margin: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: title,
          border: InputBorder.none,
        ),
      ),
    );
  }

  //-----------------------------------------
  // ダイアログ
  //-----------------------------------------
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
                  child: Text('OK'))
            ],
          );
        });
  }
}
