import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/firestore_db_service.dart';

class ChatRepository {

  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
  List<UserModel> _users = [];

  Future<List<UserModel>> getAllUsers() async {
    _users = await _fireStoreDbService.getAllUsers();
    return _users;
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



}