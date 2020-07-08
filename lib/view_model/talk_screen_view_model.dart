import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/talk_model.dart';

class TalkScreenViewModel extends ChangeNotifier {
  //------------------------
  // disposeのエラー問題解決
  //------------------------
  bool _mounted = true;

  @override
  void notifyListeners() {
    if (_mounted) super.notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
  //------------------------
  // ↑↑ここまで
  //------------------------

  List<Talk> talkList = [];
  String talk;
  String fromUserName;
  String toUserName;

  TalkScreenViewModel() {
    fetch();
  }

  CollectionReference talkCollection = Firestore.instance.collection('talk');

  //ドキュメント一覧を取得
  fetch() async {
    QuerySnapshot snapshot =
        await talkCollection.orderBy('createdAt').getDocuments();
    List<Talk> talkList = snapshot.documents
        .map((doc) => Talk(
              createdAt: doc.data['createdAt'].toDate(),
              talk: doc.data['talk'],
              uid: doc.data['uid'],
              toUserName: doc.data['toUserName'],
              fromUserName: doc.data['fromUserName'],
            ))
        .toList();
    this.talkList = talkList;
    notifyListeners();
  }

  whoSendTalk() {}

  //Talkの追加
  addTalk() async {
    String random = randomAlphaNumeric(20);
    Timestamp date = Timestamp.now();
    _toUserName();
    await talkCollection.document(random).setData({
      'createdAt': date,
      'talk': talk,
      'uid': random,
      'fromUserName': fromUserName,
      'toUserName': toUserName,
    });
    notifyListeners();
  }

  String _toUserName() {
    if (fromUserName == 'shogo') {
      toUserName = 'sakurako';
    } else {
      toUserName = 'shogo';
    }
  }

  //Talkの削除
  deleteTalk(String uid) async {
    await talkCollection.document(uid).delete();
    notifyListeners();
  }
}
