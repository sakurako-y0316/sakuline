import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/talk/talk_screen.dart';
import 'package:sakura_line/view_model/talk_room_view_model.dart';

class TalkRoomScreen extends StatelessWidget {
  //----------------------------------------
  // トーク一覧画面
  //----------------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkRoomViewModel>(
      create: (_) => TalkRoomViewModel(),
      child: Consumer<TalkRoomViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('トークルーム'),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: model.roomList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person_pin,
                        size: 60,
                      ),
                      title: model.roomList[index].friendsName != null
                          ? Text(model.roomList[index].friendsName)
                          : Text('名無し'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await model
                              .deleteRoom(model.roomList[index].talkRoomId);
                          model.fetchRoom();
                        },
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return TalkScreen(
                                  model.roomList[index].friendsName,
                                  model.roomList[index].talkRoomId);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.person_add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return AddTalkRoom();
                    },
                  ),
                );
                model.fetchRoom();
              },
            ),
          );
        },
      ),
    );
  }
}

//----------------------------------------
// トーク追加画面
//----------------------------------------
class AddTalkRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkRoomViewModel>(
      create: (_) => TalkRoomViewModel(),
      child: Consumer<TalkRoomViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('ルームの追加'),
            ),
            body: Container(
              child: ListView.builder(
                itemCount: model.userList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.person_pin,
                        size: 60,
                      ),
                      title: model.userList[index].name != null
                          ? Text(model.userList[index].name)
                          : Text('名無し'),
                      subtitle: model.userList[index].email != null
                          ? Text(model.userList[index].email)
                          : Text('匿名メール'),
                      onTap: () async {
                        await model.addRoom(model.userList[index].uid);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
