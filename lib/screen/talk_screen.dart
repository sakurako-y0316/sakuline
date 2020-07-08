import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/talk_screen_view_model.dart';

class TalkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkScreenViewModel>(
        create: (_) => TalkScreenViewModel()..fetch(),
        child: Consumer<TalkScreenViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('トーク'),
              ),
              body: Container(
                color: Colors.blue[50],
                child: ListView.builder(
                    itemCount: model.talkList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('トークの削除'),
                                content: Text('トークを削除してもよろしいですか？'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('キャンセル'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('削除'),
                                    onPressed: () async {
                                      await model.deleteTalk(
                                          model.talkList[index].uid);
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                          model.fetch();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
                          child: Center(
                              child: Row(
                            mainAxisAlignment:
                                model.talkList[index].fromUserName == 'shogo'
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  DateFormat('HH: MM')
                                      .format(model.talkList[index].createdAt)
                                      .toString(),
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                padding: EdgeInsets.all(7),
                                width: 150,
                                color: model.talkList[index].fromUserName ==
                                        'shogo'
                                    ? Colors.lightGreen[400]
                                    : Colors.white,
                                child: Text(
                                  model.talkList[index].talk,
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          )),
                        ),
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
                  model.fetch();
                },
                child: Icon(Icons.add),
              ),
            );
          },
        ));
  }
}

class AddTalk extends StatefulWidget {
  final TalkScreenViewModel model;
  AddTalk({this.model});

  @override
  _AddTalkState createState() => _AddTalkState();
}

class _AddTalkState extends State<AddTalk> {
  String userName;

  setName(String name) {
    setState(() {
      this.userName = name;
    });
    widget.model.fromUserName = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('トークを追加')),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('尚悟'),
                leading: Radio(
                  value: "shogo",
                  groupValue: userName,
                  onChanged: (val) {
                    setName(val);
                  },
                ),
              ),
              ListTile(
                title: const Text('桜子'),
                leading: Radio(
                  value: "sakurako",
                  groupValue: userName,
                  onChanged: (val) {
                    setName(val);
                  },
                ),
              ),
              TextFormField(onChanged: (val) => widget.model.talk = val),
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
                  await widget.model.addTalk();
                  widget.model.fetch();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
