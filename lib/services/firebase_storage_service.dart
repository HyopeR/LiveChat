import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_chat/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;
  var uuid = Uuid();

  @override
  Future<String> uploadProfilePhoto(String userId, String fileType, File file) async {
    _storageReference = _firebaseStorage.ref().child('users').child(userId).child(fileType).child('Profile');
    StorageUploadTask uploadTask = _storageReference.putFile(file);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url;
  }

  @override
  Future<String> uploadVoiceNote(String groupId, String fileType, File file) async {
    String voiceUniqueName = uuid.v1();
    _storageReference = _firebaseStorage.ref().child('groups').child(groupId).child(fileType).child(voiceUniqueName);
    StorageUploadTask uploadTask = _storageReference.putFile(file);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url;
  }

  @override
  Future<String> uploadImage(String groupId, String fileType, File file) async {
    String imageUniqueName = uuid.v1();
    _storageReference = _firebaseStorage.ref().child('groups').child(groupId).child(fileType).child(imageUniqueName);
    StorageUploadTask uploadTask = _storageReference.putFile(file);

    String url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url;
  }



}