import 'dart:io';

import 'package:live_chat/locator.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firebase_storage_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

class UserRepository implements AuthBase{

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  @override
  Future<UserModel> getCurrentUser() async {
    UserModel userAuth = await _firebaseAuthService.getCurrentUser();
    if (userAuth != null) {
      UserModel user = await _fireStoreDbService.readUser(userAuth.userId);
      return user;
    }
    else
      return null;

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

    bool result;
    Map<String, dynamic> checkUser = await _fireStoreDbService.checkUser(user.userId);

    if(!checkUser['check']){
      result = await _fireStoreDbService.saveUser(user);
      user = await _fireStoreDbService.readUser(user.userId);
    } else {
      result = true;
      user = checkUser['user'];
    }

    return result ? user : null;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    UserModel user = await _firebaseAuthService.signInWithFacebook();

    bool result;
    Map<String, dynamic> checkUser = await _fireStoreDbService.checkUser(user.userId);

    if(!checkUser['check']){
      result = await _fireStoreDbService.saveUser(user);
      user = await _fireStoreDbService.readUser(user.userId);
    } else {
      result = true;
      user = checkUser['user'];
    }

    return result ? user : null;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    UserModel user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
    user = await _fireStoreDbService.readUser(user.userId);

    return user;
  }

  Future<bool> controllerUser(String email) async {

    bool result = await _fireStoreDbService.checkUserWithEmail(email);
    return result;

  }

  @override
  Future<UserModel> createUserEmailAndPassword(String email, String password) async {

    UserModel user = await _firebaseAuthService.createUserEmailAndPassword(email, password);

    if(user != null) {
      bool result;
      Map<String, dynamic> checkUser = await _fireStoreDbService.checkUser(user.userId);

      if(!checkUser['check']){
        result = await _fireStoreDbService.saveUser(user);
        user = await _fireStoreDbService.readUser(user.userId);
      } else {
        result = true;
        user = checkUser['user'];
      }

      return result ? user : null;
    } else
      return null;

  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    return _fireStoreDbService.updateUserName(userId, newUserName);
  }

  Future<String> uploadFile(String userId, String fileType, File file) async {

    String fileUrl = await _firebaseStorageService.uploadFile(userId, fileType, file);
    bool fileUploadComplete = await _fireStoreDbService.updateProfilePhoto(userId, fileUrl);

    return fileUploadComplete ? fileUrl : null;
  }

}