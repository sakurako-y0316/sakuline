import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreenViewModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String name = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp(
    TextEditingController name,
    TextEditingController mail,
    TextEditingController password,
  ) async {
    if (mail == null) {
      throw ('メールアドレスを入力してください');
    }
    if (password == null) {
      throw ('パスワードを入力してください');
    }

    //①SignInに成功したら、その認証結果を取得（ユーザー情報を含む認証情報が入っている）
    final AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: mail.text,
      password: password.text,
    );

    //②Authからユーザー情報(FirebaseUser)を取り出す
    FirebaseUser _user = result.user;

    //②'現在ログインしているユーザーの情報（②を取得するための別の方法）
    // FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    //③ユーザー情報(FirebaseUser)からuid(user id = 乱数)を取得
    String _uid = _user.uid;
    String _email = _user.email;
    String _name = name.text;

    //④uidの先頭５文字を取得して、別途トークIDとして登録
    String _talkId = _uid.substring(0, 5);

    //KBoyの方法（②と③をまとめてる）端末に保存
    // final uid = result.user.uid;

    //ここからDatabaseの作成
    await Firestore.instance.collection('user').document(_uid).setData({
      'uid': _uid,
      'email': _email,
      'name': _name,
      'createdAt': Timestamp.now(),
      'talkId': _talkId,
    });
  }
}
