import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class HistoryViewModel extends ChangeNotifier {
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

  File imageFile;
  String travelName;
  DateTime dateTime;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  fetch() async {
    imageFile = null;
    travelName = null;
    dateTime = null;
    notifyListeners();
  }

  setDate(DateTime dateTime) {
    this.dateTime = dateTime;
    print("${dateTime.year}年${dateTime.month}月${dateTime.day}日です");
    notifyListeners();
  }

  setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<void> addHistory() async {
    print('登録します');
    String uid = randomAlphaNumeric(20);
    final imageURL = await _uploadImageFile();
    try {
      Firestore.instance.collection('history').document(uid).setData({
        'imageURL': imageURL,
        'travelName': travelName,
        'dateTime': dateTime,
        'createdAt': Timestamp.now(),
        'historyId': uid,
      });
    } catch (e) {
      print("DBエラー：${e.toString()}");
    }
  }

  Future<String> _uploadImageFile() async {
    if (imageFile == null) {
      return '';
    }
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('books').child(travelName);
    final snapshot = await ref
        .putFile(
          imageFile,
        )
        .onComplete;
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
