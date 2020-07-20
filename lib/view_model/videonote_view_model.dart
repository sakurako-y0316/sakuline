import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/video_model.dart';

class VideoAppViewModel extends ChangeNotifier {
  List<VideoModel> videoList = [];
  String title;
  String url = "";

  bool loading = false;

  CollectionReference videoCollection = Firestore.instance.collection('video');

  create() async {
    if (title == null || title.isEmpty) {
      print('登録失敗');
    } else {
      String uuid = randomAlphaNumeric(10);
      await videoCollection.document(uuid).setData({
        "title": title,
        "url": url,
        'videoId': uuid,
        'createdAt': Timestamp.now(),
      });

      notifyListeners();
    }
  }

  fetch() async {
    this.loading = true;
    QuerySnapshot snapshot = await videoCollection.getDocuments();
    List<VideoModel> videoList = snapshot.documents
        .map((doc) => VideoModel(
              title: doc.data['title'],
              url: doc.data['url'],
              videoId: doc.data['videoId'],
              createdAt: doc.data['createdAt'].toDate(),
            ))
        .toList();
    this.videoList = videoList;
    this.loading = false;
    notifyListeners();
  }

  edit(String movieId) async {
    await videoCollection.document(movieId).updateData({
      "title": title,
      "url": url,
      'updatedAt': Timestamp.now(),
    });
    notifyListeners();
  }

  delete(String movieId) {
    videoCollection.document(movieId).delete();
    notifyListeners();
  }
}
