import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreenViewModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: mail, password: password))
        .user;
    final email = user.email;

    Firestore.instance.collection('user').add({
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }
}
