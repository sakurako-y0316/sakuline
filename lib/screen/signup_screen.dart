import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/top_screen.dart';
import 'package:sakura_line/view_model/signup_screen_view_model.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _key = GlobalKey<FormState>();

    return ChangeNotifierProvider<SignUpScreenViewModel>(
      create: (_) => SignUpScreenViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('新規登録'),
        ),
        body: Consumer<SignUpScreenViewModel>(
            builder: (context, viewmodel, child) {
          return Form(
            key: _key,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _textForm(viewmodel, nameController, '名前', false),
                  _textForm(viewmodel, mailController, 'メールアドレス', false),
                  _textForm(viewmodel, passwordController, 'パスワード', true),
                  Container(
                    width: double.infinity,
                    color: Colors.brown[700],
                    height: 50,
                    margin: EdgeInsets.only(bottom: 20),
                    child: FlatButton(
                      onPressed: () async {
                        if (_key.currentState.validate()) {
                          try {
                            await viewmodel.signUp(
                              nameController,
                              mailController,
                              passwordController,
                            );
                            _showDialog(context, '登録完了しました', true);
                          } catch (e) {
                            await _showDialog(context, e.toString(), false);
                          }
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
            ),
          );
        }),
      ),
    );
  }

  //-----------------------------------------
  // Formの共通化
  //-----------------------------------------
  Widget _textForm(
    SignUpScreenViewModel model,
    TextEditingController controller,
    String title,
    bool password,
  ) {
    return Container(
      // color: Colors.brown[200],
      height: 80,
      child: TextFormField(
        enabled: true,
        controller: controller,
        validator: (val) => val.isEmpty ? "$titleを入力してください" : null,
        obscureText: password,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.brown[200],
          hintText: title,
          hintStyle: TextStyle(fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.brown[200]),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.brown[200]),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  //-----------------------------------------
  // ダイアログ
  //-----------------------------------------
  Future _showDialog(BuildContext context, String title, bool success) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  success
                      ? Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) {
                              return TopScreen();
                            },
                          ),
                        )
                      : Navigator.pop(context);
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }
}
