import 'package:live_chat/locator.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';

class UserRepository implements AuthBase{

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  @override
  Future<UserModel> getCurrentUser() {
    return _firebaseAuthService.getCurrentUser();
  }

  @override
  Future<UserModel> signInAnonymously() {
    return _firebaseAuthService.signInAnonymously();
  }

  @override
  Future<bool> signOut() {
    return _firebaseAuthService.signOut();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    return _firebaseAuthService.signInWithGoogle();
  }

  @override
  Future<UserModel> signInWithFacebook() {
    return _firebaseAuthService.signInWithFacebook();
  }

  @override
  Future<UserModel> signInWithEmailAndPassword() {
    return _firebaseAuthService.signInWithEmailAndPassword();
  }

  @override
  Future<UserModel> createUserEmailAndPassword() {
    return _firebaseAuthService.createUserEmailAndPassword();
  }



}