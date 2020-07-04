import 'package:flutter/material.dart';

import 'top_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 350,
          ),
          Container(
            color: Colors.brown[200],
            height: 50,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'メールアドレス',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            color: Colors.brown[200],
            height: 50,
            margin: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
            child: TextField(
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
              child: Text(
                'スキップ',
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
                onPressed: () {},
                child: Text(
                  '新規登録',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
