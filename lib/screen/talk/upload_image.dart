import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sakura_line/view_model/upload_image_view_model.dart';

//画像アップロード
class UploadImage extends StatelessWidget {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UploadImageViewModel>(
      create: (_) => UploadImageViewModel(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text('画像の追加'),
            ),
            body: Consumer<UploadImageViewModel>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          // TODO: カメラロールを開いて写真を選ぶ
                          final PickedFile pickedFile = await picker.getImage(
                              source: ImageSource.gallery);
                          model.setImage(
                            File(pickedFile.path),
                          );
                        },
                        child: SizedBox(
                          child: model.imageFile != null
                              ? Image.file(model.imageFile)
                              : Container(
                                  color: Colors.grey,
                                ),
                          width: 200,
                          height: 200,
                        ),
                      ),
                      RaisedButton(
                        child: Text('登録'),
                        onPressed: () async {
                          await model.addImageToFirebase();
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
