import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/videonote_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoNote extends StatefulWidget {
  @override
  _VideoNoteState createState() => _VideoNoteState();
}

class _VideoNoteState extends State<VideoNote> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://player.vimeo.com/external/436000332.hd.mp4?s=2e263b211d0757444ff5573e2d7f31a294a09070&profile_id=175')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoNoteViewModel>(
      create: (_) => VideoNoteViewModel()..fetch(),
      child: MaterialApp(
        title: 'Video Demo',
        home: Consumer<VideoNoteViewModel>(
          builder:
              (BuildContext context, VideoNoteViewModel model, Widget child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('動画のテスト'),
              ),
              body: Center(
                child: model.controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(model.controller),
                      )
                    : Container(),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    model.controller.value.isPlaying
                        ? model.controller.pause()
                        : model.controller.play();
                  });
                },
                child: Icon(
                  model.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
