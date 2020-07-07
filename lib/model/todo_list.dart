import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  ToDo(DocumentSnapshot doc) {
    documentID = doc.documentID;
    title = doc['title'];
  }

  String documentID;
  String title;
}
