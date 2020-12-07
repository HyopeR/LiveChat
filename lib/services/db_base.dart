import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';

abstract class DbBase {

  Future<bool> checkUserWithEmail(String userEmail);
  Future<Map<String, dynamic>> checkUser(String userId);

  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userId);
  Stream<UserModel> streamUser(String userId);

  Future<bool> updateUserName(String userId, String userName);
  Future<bool> updateStatement(String userId, String statement);
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl);
  Future<bool> updateChatWallpaper(String userId, String wallpaperUrl);

  // User'lar kendi içerisinde bir ilişki kurulmadığı için şunada bu alanlar kullanılmıyor.
  // Gerekli olan kodlar baypas edilmiş şekilde projede durmakta.

  // Future<List<UserModel>> searchUsers(String userName);
  // Future<bool> addContact(String userId, String interlocutorUserId);
  // Stream<List<UserModel>> getAllContacts(List<dynamic> contactsIdList);

  Stream<List<UserModel>> getAllUsers();
  Stream<List<GroupModel>> getAllGroups(String userId);
  Stream<List<MessageModel>> getMessages(String groupId);

  Stream<GroupModel> streamOneGroup(String groupId);
  Stream<UserModel> streamOneUser(String userId);

  // User Id'listesiyle böyle bir konuşma oluşturulmuşmu kontrolü.
  Future<GroupModel> getGroupIdByUserIdList(String userId, String groupType, List<String> userIdList);

  // Mesaj kayıt işlemi.
  Future<bool> saveMessage(MessageModel message, UserModel messageOwner, String groupId);
  Future<void> updateMessageAction(int actionCode, String userId, String groupId); // 0 eylemde değil, 1 yazıyor, 2 ses kaydediyor.

  // Grup oluşturma işlemi.
  Future<String> createGroupId();
  Future<GroupModel> createGroup(UserModel user, GroupModel group);
  Future<bool> updateGroupPhoto(String groupId, String imgUrl);
  Future<bool> updateGroupName(String groupId, String groupName);

  // Görülen mesajlara göre sayaç arttırılması.
  Future<void> messagesMarkAsSeen(String userId, String groupId, int totalMessage);

  // Girişlerde ve çıkışlarda lastSeen ve online durumunun güncellenmesi.
  Future<void> loginUpdate(String userId);
  Future<void> logoutUpdate(String userId);
}