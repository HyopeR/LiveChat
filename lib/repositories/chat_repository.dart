import 'dart:io';

import 'package:live_chat/locator.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/firebase_storage_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';
import 'package:live_chat/services/voice_record_service.dart';

class ChatRepository {

  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  VoiceRecordService _voiceRecordService = locator<VoiceRecordService>();

  Future<List<UserModel>> getAllUsers() async {
    return await _fireStoreDbService.getAllUsers();
  }

  Stream<List<GroupModel>> getAllGroups(String userId) {
    return _fireStoreDbService.getAllGroups(userId);
  }

  Stream<List<MessageModel>> getMessages(String groupId) {
    return _fireStoreDbService.getMessages(groupId);
  }

  Future<GroupModel> getGroupIdByUserIdList(String userId, String groupType, List<String> userIdList) async {
    return _fireStoreDbService.getGroupIdByUserIdList(userId, groupType, userIdList);
  }

  Future<bool> saveMessage(MessageModel message, UserModel messageOwner, String groupId) async {
    return _fireStoreDbService.saveMessage(message, messageOwner, groupId);
  }

  void recordStart() async {
    return _voiceRecordService.recordStart();
  }

  Future<File> recordStop() async {
    return _voiceRecordService.recordStop();
  }

  Future<bool> clearStorage() async {
    return _voiceRecordService.clearStorage();
  }

  Future<String> uploadVoiceNote(String groupId, String fileType, File file) async {
    return _firebaseStorageService.uploadVoiceNote(groupId, fileType, file);
  }

  Future<String> uploadImage(String groupId, String fileType, File file) async {
    return _firebaseStorageService.uploadImage(groupId, fileType, file);
  }

  void messagesMarkAsSeen(String userId, String groupId, int totalMessage) async {
    return _fireStoreDbService.messagesMarkAsSeen(userId, groupId, totalMessage);
  }



}