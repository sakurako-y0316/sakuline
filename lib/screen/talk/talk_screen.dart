import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sakura_line/screen/loading.dart';
import 'package:sakura_line/screen/talk/upload_image.dart';

import 'package:sakura_line/screen/videonote.dart';

import 'package:sakura_line/view_model/talk_screen_view_model.dart';

class TalkScreen extends StatelessWidget {
  //コンストラクタ
  TalkScreen(this.friendName, this.talkRoomId);

  final String talkRoomId;
  final String friendName;
  final TextEditingController _talkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkScreenViewModel>(
        create: (_) => TalkScreenViewModel(talkRoomId),
        child: Consumer<TalkScreenViewModel>(
          builder: (context, model, child) {
            return model.loading
                ? Loading()
                : Scaffold(
                    //-----------------------------------
                    // AppBar
                    //-----------------------------------
                    appBar: AppBar(
                      title: Text(friendName),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.ondemand_video, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) {
                                  return VideoSecondApp();
                                },
                              ),
                            );
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
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    //-----------------------------------
                    // body
                    //-----------------------------------
                    body: Column(
                      children: <Widget>[
                        //-----------------------------------
                        // トーク部分
                        //-----------------------------------
                        Expanded(
                          flex: 9,
                          child: Container(
                            color: Colors.brown[100],
                            child: ListView.builder(
                              itemCount: model.talkList.length,
                              itemBuilder: (context, index) {
                                return model.talkList[index].yourSend
                                    ?
                                    //自分が送信したトーク
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                            GestureDetector(
                                              onLongPress: () async {},
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.all(10),
                                                height: 30,
                                                color: Colors.brown[600],
                                                child: Text(
                                                  model.talkList[index].talk,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Text(model.talkList[index].createdAt
                                                .toString())
                                          ])
                                    :
                                    //相手が送信したトーク
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                            GestureDetector(
                                              onLongPress: () async {},
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                margin: EdgeInsets.all(10),
                                                height: 30,
                                                color: Colors.white,
                                                child: Text(
                                                    model.talkList[index].talk),
                                              ),
                                            ),
                                            Text(model.talkList[index].createdAt
                                                .toString())
                                          ]);
                              },
                            ),
                          ),
                        ),

                        //-----------------------------------
                        // 下部バー
                        //-----------------------------------
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 5),

                              //カメラ撮影
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(width: 5),

                              //写真の選択
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
                                          return UploadImage();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 5),

                              //入力ボックス
                              Expanded(
                                flex: 7,
                                child: Container(
                                  padding: EdgeInsets.all(7),
                                  child: TextFormField(
                                    controller: _talkController,
                                    decoration: InputDecoration(
                                        border:
                                            OutlineInputBorder(gapPadding: 5),
                                        hintText: 'Aa'),
                                  ),
                                ),
                              ),

                              //送信ボタン
                              IconButton(
                                color: Colors.brown,
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  _talkController != null
                                      ? await model.addTalk(
                                          talkRoomId,
                                          _talkController.text,
                                        )
                                      : print('入力が必要です');
                                  model.fetch(talkRoomId);
                                  _talkController.clear();
                                },
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          },
        ));
  }
}
