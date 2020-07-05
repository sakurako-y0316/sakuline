import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/talk_screen_view_model.dart';

class TalkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TalkScreenViewMdoel()..fetch(),
        child: Consumer<TalkScreenViewMdoel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('トーク'),
              ),
              body: Container(
                child: ListView.builder(
                    itemCount: model.talkList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                        child: Center(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        DateFormat('HH: MM')
                                            .format(
                                                model.talkList[index].createdAt)
                                            .toString(),
                                        style:
                                            TextStyle(color: Colors.grey[500]),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      width: 150,
                                      color: Colors.lightGreen[600],
                                      child: Text(
                                        model.talkList[index].talk,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ))),
                      );
                    }),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AddTalk(
                        model: model,
                      ),
                    ),
                  );
                  await model.fetch();
                },
                child: Icon(Icons.add),
              ),
            );
          },
        ));
  }
}

class AddTalk extends StatelessWidget {
  final TalkScreenViewMdoel model;

  const AddTalk({this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('トークを追加')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextFormField(onChanged: (val) => model.talk = val),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  '送信',
                  style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold
                  ),
                ),
                onPressed: () async {
                  await model.addTalk();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
