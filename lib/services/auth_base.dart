import 'package:live_chat/models/user_model.dart';

abstract class AuthBase {

  UserModel getCurrentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();

}