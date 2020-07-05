import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/talk_model.dart';

class TalkScreenViewMdoel extends ChangeNotifier {
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
            ))
        .toList();
    this.talkList = talkList;
    notifyListeners();
  }

  addTalk() async {
    String random = randomAlphaNumeric(20);
    await talkCollection
        .document(random)
        .setData({'createdAt': Timestamp.now(), 'talk': talk, 'uid': random});
    notifyListeners();
  }
}
