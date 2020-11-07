import 'dart:io';

import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
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

  Stream<List<ChatModel>> getAllChats(String userId) {
    return _fireStoreDbService.getAllChats(userId);
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String chatUserId) {
    return _fireStoreDbService.getMessages(currentUserId, chatUserId);
  }

  Future<bool> saveMessage(MessageModel message) async {
    return _fireStoreDbService.saveMessage(message);
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

  Future<String> uploadVoiceNote(String userId, String fileType, File file) async {
    return _firebaseStorageService.uploadVoiceNote(userId, fileType, file);
  }



}