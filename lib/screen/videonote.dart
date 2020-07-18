import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return VideoAppPage();
                }));
              },
              child: Text(
                'インドの井戸',
                // style: TextStyle(color: Colors.white),
              ),
              color: Colors.amber,
            )
          ],
        ),
      ),
    );
  }
}

class VideoAppPage extends StatefulWidget {
  @override
  _VideoAppPageState createState() => _VideoAppPageState();
}

class _VideoAppPageState extends State<VideoAppPage> {
  VideoPlayerController _controller;
  final videoUrl =
      'https://player.vimeo.com/external/439203918.hd.mp4?s=a55a16a167f3357c1ad3752d82a2aeb80148d9be&profile_id=175';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('動画プレイヤー'),
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
            Text('動画プレイヤーのテスト'),
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
