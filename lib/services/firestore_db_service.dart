import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/db_base.dart';

class FireStoreDbService implements DbBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    await _fireStore.collection('users').doc(user.userId).set(user.toMap());

    return true;
  }

  @override
  Future<UserModel> readUser(String userId) async {
    // DocumentSnapshot response = await _fireStore.collection('users').doc(userId).get();
    DocumentSnapshot response = await _fireStore.doc('users/$userId').get();
    UserModel readUser = UserModel.fromMap(response.data());

    return readUser;
  }

  @override
  Future<Map<String, dynamic>> checkUser(String userId) async {
    DocumentSnapshot response = await _fireStore.doc('users/$userId').get();
    bool checkUser = response.data() == null ? false : true;

    if (!checkUser) {
      return {'check': checkUser};
    } else {
      return {'check': checkUser, 'user': UserModel.fromMap(response.data())};
    }
  }

  @override
  Future<bool> checkUserWithEmail(String userEmail) async {
    QuerySnapshot response = await _fireStore
        .collection('users')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (response.docs.length >= 1) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async {
    QuerySnapshot response = await _fireStore
        .collection('users')
        .where('userName', isEqualTo: newUserName)
        .get();
    if (response.docs.length >= 1) {
      return false;
    } else {
      await _fireStore.collection('users').doc(userId).update({
        'userName': newUserName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String fileUrl) async {
    await _fireStore.collection('users').doc(userId).update({
      'userProfilePhotoUrl': fileUrl,
    });

    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot usersQuery = await _fireStore.collection('users').get();
    List<UserModel> users =
        usersQuery.docs.map((user) => UserModel.fromMap(user.data())).toList();

    return users;
  }

  @override
  Stream<List<ChatModel>> getAllChats(String userId) {
    var chatsQuery =  _fireStore.collection('chats')
        .where('speaker', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return chatsQuery.map((chats) => chats.docs
        .map((chat) => ChatModel.fromMap(chat.data()))
        .toList());
  }


  @override
  Stream<List<MessageModel>> getMessages(String currentUserId, String chatUserId) {
    var messagesQuery = _fireStore
        .collection('chats')
        .doc(currentUserId + '--' + chatUserId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();

    return messagesQuery.map((messages) => messages.docs
        .map((message) => MessageModel.fromMap(message.data()))
        .toList());
  }

  Future<bool> saveMessage(MessageModel message) async {

    String messageId = _fireStore.collection('chats').doc().id;
    String _senderDocumentId = message.senderId + '--' + message.receiverId;
    String _receiverDocumentId = message.receiverId + '--' + message.senderId;

    Map<String, dynamic> messageMap = message.toMap();

    await _fireStore.collection('chats').doc(_senderDocumentId)
        .collection('messages')
        .doc(messageId)
        .set(messageMap);

    await _fireStore.collection('chats').doc(_senderDocumentId).set({
      'speaker': message.senderId,
      'interlocutor': message.receiverId,
      'lastMessage': message.message,
      'seenNotification': false,
      'createdAt': FieldValue.serverTimestamp()
    });

    messageMap.update('fromMe', (value) => false);
    await _fireStore.collection('chats').doc(_receiverDocumentId)
        .collection('messages')
        .doc(messageId)
        .set(messageMap);

    await _fireStore.collection('chats').doc(_receiverDocumentId).set({
      'speaker': message.receiverId,
      'interlocutor': message.senderId,
      'lastMessage': message.message,
      'seenNotification': false,
      'createdAt': FieldValue.serverTimestamp()
    });

    return true;
  }
}
