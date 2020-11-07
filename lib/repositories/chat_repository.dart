import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/firestore_db_service.dart';
import 'package:live_chat/services/voice_record_service.dart';

class ChatRepository {

  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
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

  Future<String> recordStop() async {
    return _voiceRecordService.recordStop();
  }

  Future<bool> clearStorage() async {
    return _voiceRecordService.clearStorage();
  }



}