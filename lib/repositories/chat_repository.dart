import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/services/firestore_db_service.dart';

class ChatRepository {

  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();

  Stream<List<ChatModel>> getMessages(String currentUserId, String chatUserId) {
    return _fireStoreDbService.getMessages(currentUserId, chatUserId);
  }

  Future<bool> saveMessage(ChatModel message) async {
    return _fireStoreDbService.saveMessage(message);
  }



}