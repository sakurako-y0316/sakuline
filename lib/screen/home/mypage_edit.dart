import 'package:flutter/material.dart';

class MyPageEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ編集'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            '誕生日',
            textAlign: TextAlign.left,
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            padding: EdgeInsets.only(
              left: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
