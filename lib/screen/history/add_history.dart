import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/add_history_model.dart';

class AddHistory extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  AddHistory();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddHistoryViewModel>(
      create: (_) => AddHistoryViewModel(),
      child: Consumer<AddHistoryViewModel>(
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(title: Text('ヒストリーを追加')),
              body: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: _key,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () async {
                                  // TODO: カメラロール開いて写真選ぶ
                                  final pickedFile = await picker.getImage(
                                      source: ImageSource.gallery);
                                  try {
                                    model.setImage(
                                      File(pickedFile.path),
                                    );
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: SizedBox(
                                  width: 160,
                                  height: 100,
                                  child: model.imageFile != null
                                      ? Image.file(model.imageFile)
                                      : Container(
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                validator: (val) =>
                                    val.isEmpty ? '入力してください' : null,
                                onChanged: (val) => model.travelName = val,
                                decoration: InputDecoration(labelText: '旅の名前'),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.grey[500],
                                    child: Container(
                                      alignment: Alignment.center,
                                      // height: 50,
                                      // width: 100,
                                      child: model.dateTime != null
                                          ? Text(
                                              "${model.dateTime.year}年${model.dateTime.month}月${model.dateTime.day}日")
                                          : Text(
                                              '日付を選択',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    onPressed: () async {
                                      DateTime newDateTime =
                                          await showRoundedDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 3),
                                        lastDate:
                                            DateTime(DateTime.now().year + 1),
                                        borderRadius: 2,
                                      );
                                      if (newDateTime != null) {
                                        model.setDate(newDateTime);
                                        print(
                                          "${model.dateTime.year}年${model.dateTime.month}月${model.dateTime.day}日です",
                                        );
                                      } else {
                                        print('nullです');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              RaisedButton(
                                color: Colors.blueAccent,
                                child: Text("登録",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () async {
                                  if (_key.currentState.validate() &&
                                      model.dateTime != null) {
                                    await model.addHistory();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  model.isLoading
                      ? Center(
                          child: Container(child: CircularProgressIndicator()),
                        )
                      : SizedBox(),
                ],
              ));
        },
      ),
    );
  }
}
