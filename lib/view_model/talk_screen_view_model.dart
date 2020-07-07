import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/talk_model.dart';

class TalkScreenViewMdoel extends ChangeNotifier {
  //disposeエラー対策
  bool _mounted = false;
  bool get mounted => _mounted;

  //disposeエラー対策
  @override
  void dispose() {
    super.dispose();
    _mounted = true;
  }

  List<Talk> talkList = [];
  String talk;

  TalkScreenViewMdoel() {
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
            ))
        .toList();
    this.talkList = talkList;
    // notifyListeners();
  }

  //Talkの追加
  addTalk() async {
    String random = randomAlphaNumeric(20);
    Timestamp date = Timestamp.now();
    await talkCollection
        .document(random)
        .setData({'createdAt': date, 'talk': talk, 'uid': random});
    notifyListeners();
  }

  //Talkの削除
  deleteTalk(String uid) async {
    print('処理を始めます');
    print(uid);
    await talkCollection.document(uid).delete();
    print('削除完了');
    notifyListeners();
  }
}
