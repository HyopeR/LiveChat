import 'package:live_chat/models/user_model.dart';

abstract class DbBase {

  Future<bool> saveUser(UserModel user);

}