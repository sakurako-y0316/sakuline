import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sakura_line/model/user_model.dart';

class MyPageViewModel extends ChangeNotifier {
  List<User> user = [];
  String userName = '';
  String userId = '';
  String userImage = '';

  Future updateuser() async {
    //ログイン情報を持ってきているuid,email,
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    //ログイン情報をそのまま使用⇩⇩
    Firestore.instance.collection('user').document(_user.uid).updateData({
      'name': userName,
      'creared': Timestamp.now(),
      'image': userImage,
    });
    notifyListeners();
  }

  Future fetchusers() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    Future<DocumentSnapshot> snapshot =
        Firestore.instance.collection('user').document(_user.uid).get();
    notifyListeners();
  }
}
