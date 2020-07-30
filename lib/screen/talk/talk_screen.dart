import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/loading.dart';

import 'package:sakura_line/screen/videonote.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sakura_line/view_model/talk_screen_view_model.dart';

class TalkScreen extends StatelessWidget {
  final TextEditingController _talkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkScreenViewModel>(
        create: (_) => TalkScreenViewModel()..fetch(),
        child: Consumer<TalkScreenViewModel>(
          builder: (context, model, child) {
            return model.loading
                ? Loading()
                : Scaffold(
                    appBar: AppBar(
                      title: Text('トーク'),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.ondemand_video,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return VideoSecondApp();
                                    }));
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) {
                                      return VideoApp();
                                    }));
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    body: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 9,
                          child: Container(
                            color: Colors.brown[100],
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
                                          model.talkList[index].fromUserName ==
                                                  'shogo'
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            DateFormat('HH: MM')
                                                .format(model
                                                    .talkList[index].createdAt)
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          padding: EdgeInsets.all(7),
                                          width: 150,
                                          color: model.talkList[index]
                                                      .fromUserName ==
                                                  'shogo'
                                              ? Colors.brown[600]
                                              : Colors.white,
                                          child: Text(
                                            model.talkList[index].talk,
                                            style: model.talkList[index]
                                                        .fromUserName ==
                                                    'shogo'
                                                ? TextStyle(color: Colors.white)
                                                : TextStyle(
                                                    color: Colors.black),
                                          ),
                                        )
                                      ],
                                    )),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.image),
                                  color: Colors.brown,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  child: TextFormField(
                                    controller: _talkController,
                                    // onChanged: (val) => model.talk = val,
                                    decoration: InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        hintText: 'Aa'),
                                  ),
                                ),
                              ),
                              IconButton(
                                color: Colors.brown,
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  _talkController != null
                                      ? await model
                                          .addTalk(_talkController.text)
                                      : print('入力が必要です');
                                  model.fetchTalk();
                                  _talkController.clear();
                                },
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        )
                      ],
                    ),

                    // floatingActionButton: FloatingActionButton(
                    //   onPressed: () async {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         fullscreenDialog: true,
                    //         builder: (context) => AddTalk(
                    //           model: model,
                    //         ),
                    //       ),
                    //     );
                    //     model.fetch();
                    //   },
                    //   child: Icon(Icons.add),
                    // ),
                  );
          },
        ));
  }
}

//--------------------------------------------------
// 別画面でのトークの追加
//--------------------------------------------------
// class AddTalk extends StatefulWidget {
//   final TalkScreenViewModel model;
//   AddTalk({this.model});

//   @override
//   _AddTalkState createState() => _AddTalkState();
// }

// class _AddTalkState extends State<AddTalk> {
//   String userName;
//   TextEditingController _talkController = TextEditingController();

//   setName(String name) {
//     setState(() {
//       this.userName = name;
//     });
//     widget.model.fromUserName = name;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _key = GlobalKey<FormState>();

//     return Scaffold(
//       appBar: AppBar(title: Text('トークを追加')),
//       body: Container(
//         color: Colors.brown[100],
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _key,
//           child: Column(
//             children: <Widget>[
//               RadioListTile<String>(
//                 title: new Text('尚悟'),
//                 value: "shogo",
//                 groupValue: userName,
//                 onChanged: (val) => setName(val),
//               ),
//               RadioListTile<String>(
//                 title: new Text('桜子'),
//                 value: "sakurako",
//                 groupValue: userName,
//                 onChanged: (val) => setName(val),
//               ),
//               TextFormField(
//                 controller: _talkController,
//                 validator: (val) => val.isEmpty ? '入力してください' : null,
//                 // onChanged: (val) => widget.model.talk = val,
//               ),
//               RaisedButton(
//                 color: Colors.brown,
//                 child: Text(
//                   '送信',
//                   style: TextStyle(
//                     color: Colors.white,
//                     // fontWeight: FontWeight.bold
//                   ),
//                 ),
//                 onPressed: () async {
//                   if (_key.currentState.validate()) {
//                     if (userName == null || userName.isEmpty) {
//                       print('お前は誰だ');
//                     } else {
//                       await widget.model.addTalk();
//                       widget.model.fetch();
//                       Navigator.pop(context);
//                     }
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//画像取得
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
