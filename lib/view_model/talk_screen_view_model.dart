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
  // String talk;
  String fromUserName;
  String toUserName;
  String email;

  bool loading = false;

  TalkScreenViewModel(String talkRoomId) {
    fetch(talkRoomId);
  }

  CollectionReference talkCollection = Firestore.instance.collection('talk');

  //--------------------------------
  // ドキュメント一覧を取得
  //--------------------------------
  void fetch(String talkRoomId) async {
    // this.loading = true;

    //使用ユーザーIDを取得
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserId = currentUser.uid;

    try {
      QuerySnapshot snapshot =
          await talkCollection //中身はFirestore.instance.collection('talk');
              // .limit(3) //込み条件1
              .where('talkRoomId', isEqualTo: talkRoomId) //絞り込み条件1
              // .orderBy('createdAt') //並び替え条件
              .getDocuments(); //QuerySnapshotを取得

      List<Talk> talkList = snapshot.documents //DocumentSnapshotを順に取得
          .map((doc) => Talk(
                createdAt: doc.data['createdAt'].toDate(),
                talk: doc.data['talk'],
                talkId: doc.data['talkId'],
                senderUserId: doc.data['senderUserId'],
                yourSend:
                    doc.data['senderUserId'] == currentUserId ? true : false,
              ))
          .toList();
      this.talkList = talkList;
    } catch (e) {
      print(e.toString());
      //何もしない
    }
    // this.loading = false;

    notifyListeners();
  }

  //--------------------------------
  // トーク追加後のfetch()
  //--------------------------------
  // fetchTalk(String talkRoomId) async {
  //   QuerySnapshot snapshot =
  //       await talkCollection //中身はFirestore.instance.collection('talk');
  //           .orderBy('createdAt') //並び替え条件
  //           // .limit(3) //込み条件1
  //           .where('talkRoomId', isEqualTo: talkRoomId) //絞り込み条件1
  //           .getDocuments(); //QuerySnapshotを取得
  //   List<Talk> talkList = snapshot.documents //DocumentSnapshotを順に取得
  //       .map((doc) => Talk(
  //             createdAt: doc.data['createdAt'].toDate(),
  //             talk: doc.data['talk'],
  //             talkId: doc.data['talkId'],
  //             senderUserId: doc.data['senderUserId'],
  //           ))
  //       .toList();
  //   this.talkList = talkList;

  //   notifyListeners();
  // }

  //--------------------------------
  // ユーザーIDの取得
  //--------------------------------
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

  //--------------------------------
  // ログアウト
  //--------------------------------
  logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

  //--------------------------------
  // Authからemail情報を取得
  //--------------------------------
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

  //--------------------------------
  // Talkの追加
  //--------------------------------
  Future<void> addTalk(String talkRoomId, String talk) async {
    String random = randomAlphaNumeric(20);

    //送信者のユーザー情報を取得
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String userId = currentUser.uid;

    //Firestoreに登録
    await talkCollection.document(random).setData({
      'createdAt': Timestamp.now(),
      'talk': talk,
      'talkId': random,
      'senderUserId': userId,
      "talkRoomId": talkRoomId
    });

    notifyListeners();
  }

  //--------------------------------
  // Talkの削除
  //--------------------------------
  deleteTalk(String talkId) async {
    await talkCollection.document(talkId).delete();
    notifyListeners();
  }
}
