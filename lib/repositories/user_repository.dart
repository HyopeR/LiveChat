import 'package:live_chat/locator.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

class UserRepository implements AuthBase{

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();

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
  Future<UserModel> signInWithGoogle() async {
    UserModel user = await _firebaseAuthService.signInWithGoogle();
    bool result = await _fireStoreDbService.saveUser(user);

    return result ? user : null;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    UserModel user = await _firebaseAuthService.signInWithFacebook();
    bool result = await _fireStoreDbService.saveUser(user);

    return result ? user : null;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuthService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserModel> createUserEmailAndPassword(String email, String password) async {
    UserModel user = await _firebaseAuthService.createUserEmailAndPassword(email, password);
    bool result = await _fireStoreDbService.saveUser(user);

    return result ? user : null;
  }



}