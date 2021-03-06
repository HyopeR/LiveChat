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
  Future<void> loginUpdate(String userId) async {
    await _fireStore.collection('users').doc(userId).update({
      'online': true,
      'lastSeen': FieldValue.serverTimestamp()
    });
  }

  @override
  Future<void> logoutUpdate(String userId) async {
    await _fireStore.collection('users').doc(userId).update({
      'online': false,
      'lastSeen': FieldValue.serverTimestamp()
    });
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

    // Username başka bir user tarafından kullanılıyor mu kontrolü yapıyoruz.
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
  Future<bool> updateStatement(String userId, String statement) async {
    await _fireStore.collection('users').doc(userId).update({
      'userStatement': statement,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl) async {
    await _fireStore.collection('users').doc(userId).update({
      'userProfilePhotoUrl': profilePhotoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<bool> updateChatWallpaper(String userId, String wallpaperUrl) async {
    await _fireStore.collection('users').doc(userId).update({
      'userWallpaper': wallpaperUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }


  @override
  Future<bool> returnDefaultChatWallpaper(String userId) async {
    await _fireStore.collection('users').doc(userId).update({
      'userWallpaper': 'https://firebasestorage.googleapis.com/v0/b/flutterlivechat.appspot.com/o/system%2Fchat_wallpaper.png?alt=media&token=636b2161-c31d-4f2f-b998-5065ddde1d62',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Stream<List<UserModel>> getAllUsers() {
    Stream<QuerySnapshot> contactsQuery = _fireStore.collection('users')
        .snapshots();

    return contactsQuery.map((contacts) => contacts.docs
        .map((contact) => UserModel.fromMap(contact.data()))
        .toList());
  }


  @override
  Stream<List<GroupModel>> getAllGroups(String userId) {
    Stream<QuerySnapshot> groupsQuery =  _fireStore.collection('groups')
        .where('members', arrayContains: userId)
        .orderBy('recentMessage.date', descending: true)
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
        .where('groupType', isEqualTo: 'Private')
        .get();

    // Grup varsa var olanı döndürür.
    if(groupQuery.docs.length > 0) {
      return groupQuery.docs.map((DocumentSnapshot groupDocument) => GroupModel.fromMapPlural(groupDocument.data())).first;
    }

    // Grup yok ise var olan kullanıcıların roomlarını güncelleyip, yeni bir room oluşturup döndürürüz.
    else {
      String groupId = _fireStore.collection('groups').doc().id;

      // Grupta olacak her bir user için okunmamış mesaj değerlerini tutacak bir map yapısı oluşturuyoruz.
      Map<String, Map<String, dynamic>> actions = {};
      userIdList.forEach((userId) => actions[userId] = {'seenMessage': 0, 'action': 0});

      GroupModel createGroup = GroupModel.private(
        groupId: groupId,
        groupType: groupType,
        members: userIdList,
        actions: actions,
        totalMessage: 0,
        createdBy: userId,
      );

      // Userların bir gruba dahil olduklarında groups alanlarına girdiği grubun id'sini ekliyoruz.
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

  Future<bool> saveMessage(MessageModel message, UserModel messageOwner, String groupId) async {

    // Firestore'dan unique bir id elde ediyoruz.
    String messageId = _fireStore.collection('chats').doc().id;

    // Message modelimizi firebase'e eklemek için map'e dönüştürüyoruz.
    // MessageType verisi voice olmayanlardan duration key'ini siliyoruz.
    Map<String, dynamic> messageMap = message.toMap();
    messageMap['messageId'] = messageId;

    // Mesaj tipi voice değil ise duration key silinir.
    if(message.messageType != 'Voice')
      messageMap.remove('duration');

    // Resim gönderilerinde text olarak mesaj alanı boş ise key silinir.
    if(message.message.trim().length < 1)
      messageMap.remove('message');

    await _fireStore.collection('chats').doc(groupId)
        .collection('messages')
        .doc(messageId)
        .set(messageMap);

    // Groups koleksiyonunda mesaj verilerine ek olarak mesaj sahibinin bazı bilgilerinide işlem yapmak için
    // groups koleksiyonu altına ekleyeceğimiz message map'in içine ekliyoruz.
    messageMap['ownerUsername'] = messageOwner.userName;
    messageMap['ownerImageUrl'] = messageOwner.userProfilePhotoUrl;
    if(messageMap['markedMessage'] != null)
      messageMap.remove('markedMessage');

    // Son mesajı gruba kaydetme sırasında aynı zamanda mesajı gönderen kişinin seen message alanını ve
    // total message alanlarını 1 arttırıyoruz.

    if(message.messageType != 'System') {
      await _fireStore.collection('groups').doc(groupId).update({
        'recentMessage': messageMap,
        'totalMessage': FieldValue.increment(1),
        'actions.${messageOwner.userId}.seenMessage': FieldValue.increment(1)
      });
    } else {
      await _fireStore.collection('groups').doc(groupId).update({
        'recentMessage': messageMap,
      });
    }

    return true;
  }

  @override
  Future<void> messagesMarkAsSeen(String userId, String groupId, int totalMessage) async {
    await _fireStore.collection('groups').doc(groupId).update({
      'actions.$userId.seenMessage': totalMessage
    });
  }

  @override
  Future<void> updateMessageAction(int actionCode, String userId, String groupId) async {
    await _fireStore.collection('groups').doc(groupId).update({
      'actions.$userId.action': actionCode
    });
  }

  @override
  Stream<GroupModel> streamOneGroup(String groupId) {
    Stream<DocumentSnapshot> groupDoc =  _fireStore.collection('groups').doc(groupId).snapshots();

    return groupDoc.map((group) {
      if(group.data()['groupType'] == 'Private')
        return GroupModel.fromMapPrivate(group.data());
      else
        return GroupModel.fromMapPlural(group.data());
    });
  }

  @override
  Stream<UserModel> streamOneUser(String userId) {
    Stream<DocumentSnapshot> userDoc =  _fireStore.collection('users').doc(userId).snapshots();

    return userDoc.map((user) => UserModel.fromMap(user.data()));
  }

  @override
  Future<String> createGroupId() async {
    String groupId = _fireStore.collection('groups').doc().id;
    return groupId;
  }

  @override
  Future<GroupModel> createGroup(UserModel user, GroupModel group) async {
    // Grupta olacak her bir user için okunmamış mesaj değerlerini tutacak bir map yapısı oluşturuyoruz.
    Map<String, Map<String, dynamic>> actions = {};
    group.members.forEach((userId) => actions[userId] = {'seenMessage': 0, 'action': 0});

    GroupModel createdGroup = group;
    createdGroup.actions = actions;

    createdGroup.members.forEach((userId) {
      DocumentReference userReference = _fireStore.collection('users').doc(userId);
      userReference.update({
        'groups': FieldValue.arrayUnion([createdGroup.groupId])
      });
    });

    MessageModel systemMessage = MessageModel(
      sendBy: user.userId,
      message: 'Grup oluşturdu.',
      messageType: 'System'
    );

    await _fireStore.collection('groups').doc(createdGroup.groupId).set(createdGroup.toMapPlural());
    await saveMessage(systemMessage, user, createdGroup.groupId);

    return group;
  }

  @override
  Future<bool> updateGroupPhoto(String groupId, String imgUrl) async {
    await _fireStore.collection('groups').doc(groupId).update({
      'groupImageUrl': imgUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<bool> updateGroupName(String groupId, String groupName) async {
    await _fireStore.collection('groups').doc(groupId).update({
      'groupName': groupName,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }


// @override
// Future<List<UserModel>> searchUsers(String userName) async {
//   QuerySnapshot usersQuery;
//
//   if(userName.trim().length > 0) {
//     usersQuery = await _fireStore.collection('users').orderBy('userName').startAt([userName]).endAt([userName]).get();
//   } else {
//     usersQuery = await _fireStore.collection('users').get();
//   }
//
//   List<UserModel> users = usersQuery.docs.map((user) => UserModel.fromMap(user.data())).toList();
//   return users;
// }
//
// @override
// Stream<List<UserModel>> getAllContacts(List<dynamic> contactsIdList) {
//   List<dynamic> whereList = contactsIdList;
//   if(contactsIdList.length < 1)
//     whereList.add('EmptyId');
//
//   Stream<QuerySnapshot> contactsQuery = _fireStore.collection('users')
//       .where('userId', whereIn: contactsIdList)
//       .snapshots();
//
//   return contactsQuery.map((contacts) => contacts.docs
//       .map((contact) => UserModel.fromMap(contact.data()))
//       .toList());
// }
//
// @override
// Future<bool> addContact(String userId, String interlocutorUserId) async {
//   await _fireStore.collection('users').doc(userId).update({
//     'contacts': FieldValue.arrayUnion([interlocutorUserId]),
//   });
//
//   await _fireStore.collection('users').doc(interlocutorUserId).update({
//     'contacts': FieldValue.arrayUnion([userId]),
//   });
//
//   return true;
// }

}
