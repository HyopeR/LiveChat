import 'package:live_chat/models/user_model.dart';

abstract class AuthBase {

  Future<UserModel> getCurrentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();

}