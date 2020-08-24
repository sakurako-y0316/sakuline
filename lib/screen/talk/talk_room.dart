import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/screen/talk/talk_screen.dart';
import 'package:sakura_line/view_model/talk_room_view_model.dart';

class TalkRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkRoomViewModel>(
      create: (_) => TalkRoomViewModel()..fetchRoom(),
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
                      title: model.roomList[index].talkRoomId != null
                          ? Text(model.roomList[index].talkRoomId)
                          : Text('名無し'),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return TalkScreen();
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return AddTalkRoom();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AddTalkRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TalkRoomViewModel>(
      create: (_) => TalkRoomViewModel()..fetch(),
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
                        print('push');
                        await model.addRoom(model.userList[index].uid);
                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return TalkScreen();
                        //     },
                        //   ),
                        // );
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
