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

    print('今から登録します');
    //①SignInに成功したら、その認証結果を取得（ユーザー情報を含む認証情報が入っている）

    final AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: mail, password: password);
    print('認証情報登録しました');
    //②Authからユーザー情報(FirebaseUser)を取り出す
    FirebaseUser _user = result.user;

    //②'現在ログインしているユーザーの情報（②を取得するための別の方法）
    // FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    //③ユーザー情報(FirebaseUser)からuid(user id = 乱数)を取得
    String _uid = _user.uid;
    String _email = _user.email;

    //KBoyの方法（②と③をまとめてる）端末に保存
    // final uid = result.user.uid;

    //ここからDatabaseの作成
    await Firestore.instance.collection('user').document(_uid).setData({
      'uid': _uid,
      'email': _email,
      'createdAt': Timestamp.now(),
    });
    print('登録しました');
  }
}
