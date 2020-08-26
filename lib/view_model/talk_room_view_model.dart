import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:sakura_line/model/talk_room_model.dart';
import 'package:sakura_line/model/user_model.dart';

class TalkRoomViewModel extends ChangeNotifier {
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

  //コンストラクター
  TalkRoomViewModel() {
    fetch();
  }

  List<User> userList = [];
  List<TalkRoom> roomList = [];
  List<dynamic> memberId = [];
  String friendsId;
  String friendsName;
  bool isLoading = false;

  CollectionReference userCollection = Firestore.instance.collection('user');
  CollectionReference talkRoomCollection =
      Firestore.instance.collection('talkRoom');

  //トークルームの取得
  Future<List<TalkRoom>> fetchRoom() async {
    try {
      //現在のユーザーのUID
      FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
      String fbUserId = fbUser.uid;

      //UserModelの取得
      QuerySnapshot userSnapshot = await userCollection.getDocuments();
      List<User> userList = userSnapshot.documents
          .map((doc) => User(
                uid: doc.data['uid'],
                name: doc.data['name'],
              ))
          .toList();
      this.userList = userList;

      //TalkRoomModelの取得
      QuerySnapshot roomSnapshot = await talkRoomCollection.getDocuments();
      List<TalkRoom> roomList = roomSnapshot.documents
          .map((doc) => TalkRoom(
              talkRoomId: doc.data['talkRoomId'],
              memberId: doc.data['memberId'],
              friendsName:
                  getFriendNameFromMemberId(doc.data['memberId'], fbUserId)))
          .toList();

      this.roomList = roomList;

      notifyListeners();
      return roomList;
    } catch (e) {
      print("エラー1${e.toString()}");
      return null;
    }
  }

  //memberIdとuidが一致するユーザーを取得
  String getFriendNameFromMemberId(
      List<dynamic> memberId, String currentUserId) {
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].uid == memberId[0] && userList[i].uid != currentUserId) {
        return userList[i].name;
      } else if (userList[i].uid == memberId[1] &&
          userList[i].uid != currentUserId) {
        return userList[i].name;
      }
    }
  }

  //ユーザーリストの取得
  Future<List<User>> fetch() async {
    try {
      QuerySnapshot snapshot = await userCollection.getDocuments();
      List<User> userList = snapshot.documents
          .map(
            (doc) => User(
              uid: doc.data['uid'],
              name: doc.data['name'],
              email: doc.data['email'],
            ),
          )
          .toList();
      this.userList = userList;
      notifyListeners();
      return userList;
    } catch (e) {
      print("エラー2${e.toString()}");
      return null;
    }
  }

  //トークルームの削除
  deleteRoom(String roomId) {
    talkRoomCollection.document(roomId).delete();
    notifyListeners();
  }

  addRoom(String friendsId) async {
    String randomRoom = randomAlphaNumeric(20);

    //自分の情報を取得
    FirebaseUser myInfo = await FirebaseAuth.instance.currentUser();
    String myUid = myInfo.uid;
    DocumentSnapshot docSnapshot = await userCollection.document(myUid).get();
    String myId = docSnapshot.data['uid'];

    this.memberId = [myId, friendsId];
    notifyListeners();

    await talkRoomCollection
        .document(randomRoom)
        .setData({'talkRoomId': randomRoom, 'memberId': this.memberId});
    notifyListeners();
  }
}
