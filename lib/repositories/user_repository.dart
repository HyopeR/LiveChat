import 'dart:io';

import 'package:live_chat/locator.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firebase_storage_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

/*
  Bir sınıftan implements edlirse metodlar ezilemez.
  Ancak bir sınıftan extends edilen sınıflar metodları ezebilir.
*/

class UserRepository implements AuthBase{

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  @override
  Future<UserModel> getCurrentUser() async {
    UserModel userAuth = await _firebaseAuthService.getCurrentUser();
    if (userAuth != null) {
      // UserModel user = await _fireStoreDbService.readUser(userAuth.userId);
      return userAuth;
    }
    else
      return null;
  }

  Stream<UserModel> streamCurrentUser(String userId) {
    return _fireStoreDbService.streamUser(userId);
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

  Future<bool> updateStatement(String userId, String statement) async {
    return _fireStoreDbService.updateStatement(userId, statement);
  }

  Future<String> updateProfilePhoto(String userId, String fileType, File file) async {
    String profilePhotoUrl = await _firebaseStorageService.uploadProfilePhoto(userId, fileType, file);
    bool fileUploadComplete = await _fireStoreDbService.updateProfilePhoto(userId, profilePhotoUrl);

    return fileUploadComplete ? profilePhotoUrl : null;
  }

  Future<String> updateChatWallpaper(String userId, String fileType, File file) async {
    String chatWallpaperUrl = await _firebaseStorageService.uploadChatWallpaper(userId, fileType, file);
    bool fileUploadComplete = await _fireStoreDbService.updateChatWallpaper(userId, chatWallpaperUrl);

    return fileUploadComplete ? chatWallpaperUrl : null;
  }

  Future<bool> returnDefaultChatWallpaper(String userId) async {
    return _fireStoreDbService.returnDefaultChatWallpaper(userId);
  }

  Future<void> loginUpdate(String userId) async {
    return _fireStoreDbService.loginUpdate(userId);
  }

  Future<void> logoutUpdate(String userId) async {
    return _fireStoreDbService.logoutUpdate(userId);
  }

// Future<bool> addContact(String userId, String interlocutorUserId) async {
//   return _fireStoreDbService.addContact(userId, interlocutorUserId);
// }

}