import 'package:live_chat/models/user_model.dart';

abstract class DbBase {

  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userId);
  Future<Map<String, dynamic>> checkUser(String userId);
  Future<bool> updateUserName(String userId, String userName);

}