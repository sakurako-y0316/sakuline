import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sakura_line/model/history_model.dart';

class HistoryViewModel extends ChangeNotifier {
  List<History> historyList = [];

  fetchHistory() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('history').getDocuments();

    snapshot.documents
        .map((doc) => History(
              historyId: doc.data['historyId'],
              //-----------------------------
              // 途中経過
              //-----------------------------

              //     "dateTime":doc.dateTime.toString(),
              // "historyId":doc.,
              // "imageURL":,
              // "travelName":,
            ))
        .toList();
  }
}
