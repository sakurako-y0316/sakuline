import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadImageViewModel extends ChangeNotifier {
  File imageFile;
  bool isLoading = false;

  void setImage(File imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<void> addImageToFirebase() async {
    this.isLoading = true;
    final String imageUrl = await _uploadImageFile();

    Firestore.instance.collection('image').add(
      {
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      },
    );
    this.isLoading = false;
  }

  Future<String> _uploadImageFile() async {
    if (imageFile == null) {
      return '';
    }
    final FirebaseStorage storage = FirebaseStorage.instance;
    final StorageReference ref = storage.ref().child('talk').child("test");
    final StorageTaskSnapshot snapshot =
        await ref.putFile(imageFile).onComplete;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
