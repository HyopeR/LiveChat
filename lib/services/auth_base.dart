import 'package:live_chat/models/user_model.dart';

abstract class AuthBase {

  Future<UserModel> getCurrentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserEmailAndPassword(String email, String password);
}