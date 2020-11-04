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

  Future<List<ChatModel>> getAllChats(String userId) async {
    List<ChatModel> chats = await _fireStoreDbService.getAllChats(userId);

    for(var chat in chats) {
      UserModel interlocutor = findUserFromList(chat.interlocutor);
      if(interlocutor != null) {
        chat.interlocutorProfilePhotoUrl = interlocutor.userProfilePhotoUrl;
        chat.interlocutorUserName = interlocutor.userName;
        chat.interlocutorEmail = interlocutor.userEmail;
      }
    }

    return chats;
  }

  UserModel findUserFromList(String findUserId) {
    var findUser = _users.map((user) {
      if(user.userId == findUserId)
        return user;
    }).toList();

    return findUser[0];
  }

  Stream<List<MessageModel>> getMessages(String currentUserId, String chatUserId) {
    return _fireStoreDbService.getMessages(currentUserId, chatUserId);
  }

  Future<bool> saveMessage(MessageModel message) async {
    return _fireStoreDbService.saveMessage(message);
  }



}