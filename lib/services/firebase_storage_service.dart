import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_chat/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(String userId, String fileType, File file) async {
    _storageReference = _firebaseStorage.ref().child(userId).child(fileType).child('Profile');
    StorageUploadTask uploadTask = _storageReference.putFile(file);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url;
  }



}