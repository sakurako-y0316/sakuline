import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/model/video_model.dart';
import 'package:sakura_line/view_model/videonote_view_model.dart';

import 'package:video_player/video_player.dart';

//-------------------------------------------
// 動画一覧画面
//-------------------------------------------
class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoAppViewModel>(
      create: (_) => VideoAppViewModel()..fetch(),
      child: Consumer<VideoAppViewModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('動画一覧'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  model.fetch();
                },
              )
            ],
          ),
          body: ListView.builder(
            itemCount: model.videoList.length,
            itemBuilder: (context, index) => Card(
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                actions: <Widget>[
                  IconSlideAction(
                    caption: '編集',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditVideo(
                          videoModel: model.videoList[index],
                        );
                      }));
                      model.fetch();
                    },
                  )
                ],
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      await model.delete(model.videoList[index].videoId);
                      model.fetch();
                    },
                  )
                ],
                child: ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text(model.videoList[index].title),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return VideoAppPage(
                        vModel: model.videoList[index],
                      );
                    }));
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return AddVideo();
                  }));
              model.fetch();
            },
          ),
        );
      }),
    );
  }
}

//-------------------------------------------
// 動画の表示
//-------------------------------------------
class VideoAppPage extends StatefulWidget {
  final VideoModel vModel;
  const VideoAppPage({this.vModel});

  @override
  _VideoAppPageState createState() => _VideoAppPageState();
}

class _VideoAppPageState extends State<VideoAppPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.vModel.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.vModel.title),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: <Widget>[
              _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
              Text(widget.vModel.title),
            ],
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

//-------------------------------------------
// 動画の追加
//-------------------------------------------
class AddVideo extends StatelessWidget {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoAppViewModel>(
        create: (_) => VideoAppViewModel(),
        child: Consumer<VideoAppViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('動画の追加'),
              ),
              body: Container(
                padding: EdgeInsets.all(40),
                child: Form(
                  key: _key,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusColor: Colors.green,
                              fillColor: Colors.white,
                              hintText: 'タイトル'),
                          validator: (val) => val.isEmpty ? '入力してください' : null,
                          onChanged: (val) {
                            model.title = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusColor: Colors.green,
                              fillColor: Colors.white,
                              hintText: '動画 URL'),
                          // validator: (val) => val.isEmpty ? '入力してください' : null,
                          onChanged: (val) {
                            model.url = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            '登録',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              await model.create();
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}

//-------------------------------------------
// 動画の編集
//-------------------------------------------
class EditVideo extends StatelessWidget {
  final VideoModel videoModel;
  final _key = GlobalKey<FormState>();

  EditVideo({this.videoModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoAppViewModel>(
        create: (_) => VideoAppViewModel(),
        child: Consumer<VideoAppViewModel>(
          builder: (context, model, child) {
            model.title = videoModel.title;
            model.url = videoModel.url;

            return Scaffold(
              appBar: AppBar(
                title: Text('動画の修正'),
              ),
              body: Container(
                padding: EdgeInsets.all(40),
                child: Form(
                  key: _key,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: videoModel.title,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusColor: Colors.green,
                              fillColor: Colors.white,
                              hintText: 'タイトル'),
                          validator: (val) => val.isEmpty ? '入力してください' : null,
                          onChanged: (val) {
                            model.title = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: videoModel.url,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusColor: Colors.green,
                              fillColor: Colors.white,
                              hintText: '動画 URL'),
                          // validator: (val) => val.isEmpty ? '入力してください' : null,
                          onChanged: (val) {
                            model.url = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            '修正',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_key.currentState.validate()) {
                              await model.edit(videoModel.videoId);
                              Navigator.pop(context);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
