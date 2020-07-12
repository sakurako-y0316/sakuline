import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoNoteViewModel extends ChangeNotifier {
  VideoPlayerController controller;
  String _videoUrl =
      'https://player.vimeo.com/external/436000332.hd.mp4?s=2e263b211d0757444ff5573e2d7f31a294a09070&profile_id=175';

  fetch() async {
    print('fetchします');
    controller = VideoPlayerController.network(_videoUrl);
    print('fetch終了');
    notifyListeners();
  }

  void dispose() {
    print('disposeします');
    super.dispose();
    controller.dispose();
    notifyListeners();
  }
}
