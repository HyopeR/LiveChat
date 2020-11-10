import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/group_model.dart';
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
  Stream<UserModel> streamUser(String userId) {
    Stream<DocumentSnapshot> streamUser = _fireStore.collection('users').doc(userId).snapshots();

    return streamUser.map((user) => UserModel.fromMap(user.data()));
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

    // Username alınmış mı kontrolü
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
      'updatedAt': FieldValue.serverTimestamp(),
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
  Stream<List<GroupModel>> getAllGroups(String userId) {
    var groupsQuery =  _fireStore.collection('groups')
        .where('members', arrayContains: userId)
        .orderBy('recentMessageDate', descending: true)
        .snapshots();

    return groupsQuery.map((groups) => groups.docs
        .map((group) => GroupModel.fromMapPlural(group.data()))
        .toList());
  }

  @override
  Stream<List<MessageModel>> getMessages(String groupId) {
    var messagesQuery = _fireStore.collection('chats')
        .doc(groupId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();

    return messagesQuery.map((messages) => messages.docs
        .map((message) => MessageModel.fromMap(message.data()))
        .toList());

  }

  @override
  Future<GroupModel> getGroupIdByUserIdList(String userId, String groupType, List<String> userIdList) async {
    QuerySnapshot groupQuery = await _fireStore.collection('groups')
        .where('members', isEqualTo: userIdList)
        .get();

    // Grup varsa var olanı döndürür.
    if(groupQuery.docs.length > 0) {
      return groupQuery.docs.map((DocumentSnapshot groupDocument) => GroupModel.fromMapPlural(groupDocument.data())).first;
    }

    // Grup yok ise var olan kullanıcıların roomlarını güncelleyip, yeni bir room oluşturup döndürürüz.
    else {
      String groupId = _fireStore.collection('groups').doc().id;
      GroupModel createGroup = GroupModel.private(
        groupId: groupId,
        groupType: groupType,
        members: userIdList,
        createdBy: userId
      );

      userIdList.forEach((userId) {
        DocumentReference userReference = _fireStore.collection('users').doc(userId);
        userReference.update({
          'groups': FieldValue.arrayUnion([groupId])
        });
      });

      await _fireStore.collection('groups').doc(groupId).set(createGroup.toMapPrivate());
      return createGroup;
    }
  }

  Future<bool> saveMessage(MessageModel message, String groupId) async {

    String messageId = _fireStore.collection('chats').doc().id;

    Map<String, dynamic> messageMap = message.toMap();
    if(message.messageType != 'Voice')
      messageMap.remove('duration');

    await _fireStore.collection('groups').doc(groupId).update({
      'recentMessage': message.message,
      'recentMessageDate': FieldValue.serverTimestamp(),
      'sentBy': message.sendBy
    });

    await _fireStore.collection('chats').doc(groupId)
        .collection('messages')
        .doc(messageId)
        .set(messageMap);

    return true;
  }

}
