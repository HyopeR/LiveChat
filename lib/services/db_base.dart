import 'package:live_chat/models/user_model.dart';

abstract class DbBase {

  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userId);
  Future<Map<String, dynamic>> checkUser(String userId);
  Future<bool> checkUserWithEmail(String userEmail);
  Future<bool> updateUserName(String userId, String userName);
  Future<bool> updateProfilePhoto(String userId, String photoUrl);
  Future<List<UserModel>> getAllUsers();
}