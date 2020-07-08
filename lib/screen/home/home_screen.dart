import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.red[100],
            ),
            onPressed: () {},
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.red[100],
          ),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.only(
                left: 8,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                    hintText: ('検索'),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Container(
                    height: 100,
                    child: Image.asset('lib/assets/images/0007.jpg')),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Sakurako Yoshida',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
