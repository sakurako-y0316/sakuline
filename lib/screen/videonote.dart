import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/model/video_model.dart';
import 'package:sakura_line/screen/loading.dart';
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
        return model.loading
            ? Loading()
            : Scaffold(
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
    return ChangeNotifierProvider<VideoAppViewModel>(
      create: (_) => VideoAppViewModel()..fetch(),
      child: Consumer<VideoAppViewModel>(
        builder: (context, model, child) => model.loading
            ? Loading()
            : Scaffold(
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
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                )),
      ),
    );
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

//------------------------------------------------------------
// 動画の編集
//------------------------------------------------------------
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
      ),
    );
  }
}

//-------------------------------------------
// 詳細サンプルコード（video_player）
//-------------------------------------------
class VideoSecondApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: const ValueKey<String>('home_page'),
        appBar: AppBar(
          title: const Text('Video player example'),
          actions: <Widget>[
            IconButton(
              key: const ValueKey<String>('push_tab'),
              icon: const Icon(Icons.navigation),
              onPressed: () {
                Navigator.push<_PlayerVideoAndPopPage>(
                  context,
                  MaterialPageRoute<_PlayerVideoAndPopPage>(
                    builder: (BuildContext context) => _PlayerVideoAndPopPage(),
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud),
                text: "Remote",
              ),
              Tab(icon: Icon(Icons.insert_drive_file), text: "Asset"),
              Tab(icon: Icon(Icons.list), text: "List example"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _BumbleBeeRemoteVideo(),
            _ButterFlyAssetVideo(),
            _ButterFlyAssetVideoInList(),
          ],
        ),
      ),
    );
  }
}

class _ButterFlyAssetVideoInList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _ExampleCard(title: "Item a"),
        _ExampleCard(title: "Item b"),
        _ExampleCard(title: "Item c"),
        _ExampleCard(title: "Item d"),
        _ExampleCard(title: "Item e"),
        _ExampleCard(title: "Item f"),
        _ExampleCard(title: "Item g"),
        Card(
            child: Column(children: <Widget>[
          Column(
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.cake),
                title: Text("Video video"),
              ),
              Stack(
                  alignment: FractionalOffset.bottomRight +
                      const FractionalOffset(-0.1, -0.1),
                  children: <Widget>[
                    _ButterFlyAssetVideo(),
                    //画像
                    Image.asset('0007.jpg'),
                  ]),
            ],
          ),
        ])),
        _ExampleCard(title: "Item h"),
        _ExampleCard(title: "Item i"),
        _ExampleCard(title: "Item j"),
        _ExampleCard(title: "Item k"),
        _ExampleCard(title: "Item l"),
      ],
    );
  }
}

/// A filler card to show the video in a list of scrolling contents.
class _ExampleCard extends StatelessWidget {
  const _ExampleCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.airline_seat_flat_angled),
            title: Text(title),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: const Text('BUY TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
              FlatButton(
                child: const Text('SELL TICKETS'),
                onPressed: () {
                  /* ... */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ButterFlyAssetVideo extends StatefulWidget {
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://player.vimeo.com/external/439203918.hd.mp4?s=a55a16a167f3357c1ad3752d82a2aeb80148d9be&profile_id=175");

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          const Text('With assets mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  _PlayPauseOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  VideoPlayerController _controller;

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/bumble_bee_captions.srt');
    return SubRipCaptionFile(fileContents);
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://player.vimeo.com/external/436000332.hd.mp4?s=2e263b211d0757444ff5573e2d7f31a294a09070&profile_id=175',
      closedCaptionFile: _loadCaptions(),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(padding: const EdgeInsets.only(top: 20.0)),
          const Text('With remote mp4'),
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  ClosedCaption(text: _controller.value.caption.text),
                  _PlayPauseOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
        'https://player.vimeo.com/external/436000332.hd.mp4?s=2e263b211d0757444ff5573e2d7f31a294a09070&profile_id=175');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
