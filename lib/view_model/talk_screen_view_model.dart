import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String email;

  TalkScreenViewModel() {
    fetch();
  }

  CollectionReference talkCollection = Firestore.instance.collection('talk');

  // ユーザーIDの取得
  Future<String> getUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    try {
      String email = _user.email;
      print("email:$email");
      this.email = email;
      return this.email;
    } catch (e) {
      print("取得できません${e.toString()}");
    }
    this.email = email;
    return this.email;
  }

  // ログアウト
  logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  //Authからemail情報を取得
  Future<String> getEmail() async {
    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      this.email = _user.email;
      return email;
    } catch (e) {
      print("emailの取得失敗：${e.toString()}");
    }
    return null;
  }

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

    getEmail();

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
